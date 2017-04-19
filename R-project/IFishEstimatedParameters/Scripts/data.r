#!/usr/bin/Rscript
# file: data.r
# purpose: Generate estimated parameters
# by: Peter Mous [pjmous@gmail.com], Gede Wawan [gede.wawan@gmail.com]
# date first version: Feb 20, 2017
# date this version:
# requires:

# load packages
library(RPostgreSQL)
library(memisc)
library(lme4, lib.loc="/root/R-project/lib/")
library(bootstrap, lib.loc="/root/R-project/lib/")
library(fishmethods, lib.loc="/root/R-project/lib/")
library(WriteXLS)

# remove all objects
rm(list=ls())

# Start postgres with $sudo systemctl start postgresql
# create a PostgreSQL instance and create one connection.
m <- dbDriver("PostgreSQL")
con1 <- dbConnect(m, user="postgres", password="postgres", dbname="ifish_community")

# Quering data of sizing
rs <- dbSendQuery(con1, "select f.fish_id, lmat, lmatm, lopt, linf, lmax, landing_date, cm, b.name as boat, approach from ifish_fish f inner join ifish_sizing s on f.oid = s.fish_id inner join ifish_deepslope d on s.landing_id = d.oid inner join ifish_boat b on d.boat_id = b.oid where f.fish_id > 0 and s.data_quality = 1 and ((d.approach = 0 and d.landing_date < '2015-10-06') or (d.approach = 2 and d.landing_date >= '2015-10-06')) and fishery_type = any(values('Snapper')) and doc_status = any(values('Posted'));")
dbHasCompleted(rs) # TRUE if all records have been fetched from the database
df <- fetch(rs, n = -1)
df$EcoSize <- cases("Immature" = df$cm<df$lmat, "SmallMature" = df$cm<=df$lopt, "LargeMature" = df$cm<df$lopt*1.1, "MegaSpawner" = TRUE)

# Quering all species 
rs2 <- dbSendQuery(con1, paste("select * from (select f.fish_id, f.fish_family, f.fish_genus, f.fish_species, f.lmat, f.lopt, f.linf, f.lmax, var_a, var_b, count(s.*) as n from ifish_fish f inner join ifish_sizing s on f.oid = s.fish_id inner join ifish_deepslope d on s.landing_id = d.oid where f.fish_id > 0 and s.data_quality = 1 and ((d.approach = 0 and d.landing_date < '2015-10-06') or (d.approach = 2 and d.landing_date >= '2015-10-06')) and fishery_type = any(values('Snapper')) and doc_status = any(values('Posted')) group by 1,2,3,4,5,6,7,8,9,10) as t1 order by n desc;", sep=""))
dbHasCompleted(rs2) # TRUE if all records have been fetched from the database
SPP <- fetch(rs2, n = -1)

# START PROCESS
dfResult <- data.frame();

for(idx in sort((unique(SPP$fish_id)))){
    spx <- subset(SPP,fish_id==idx)
    dfx <- subset(df, fish_id==idx)

    if(nrow(dfx) > 0) {

        # Calculate percentages immature, small mature, large mature
        perc_imm <- 100*length(dfx$EcoSize[dfx$EcoSize=="Immature" & !is.na(dfx$EcoSize)])/length(dfx$cm)
        perc_smat <- 100*length(dfx$EcoSize[dfx$EcoSize=="SmallMature" & !is.na(dfx$EcoSize)])/length(dfx$cm)
        perc_lmat <- 100*length(dfx$EcoSize[dfx$EcoSize=="LargeMature" | dfx$EcoSize=="MegaSpawner" & !is.na(dfx$EcoSize)])/length(dfx$cm)
        perc_megasp <- 100*length(dfx$EcoSize[dfx$EcoSize=="MegaSpawner" & !is.na(dfx$EcoSize)])/length(dfx$cm)
        perc_yopt <- 100*length(dfx$cm[dfx$cm>(spx$lopt-(spx$lopt*0.1)) & dfx$cm<(spx$lopt+(spx$lopt*0.1))])/length(dfx$cm)


        #### SPR START HERE
        lc <- 0
        lc_sub <- 0

        perc_spr <- 0
        text_spr <- paste("unknown")

        perc_BoverB0 <- 0
        text_BoverB0 <- paste("unknown")

        Mnat <- 0 # natural mortality 
        Fmax <- 0 # fishing mortaltity
        ratio_FvsM <- 0 # F vs M
        text_FvsM <- paste("unknown")

        # Calculate Von Bertalanffy growth paramenter K using L infinity and L opt (Froese and Binohlan 2000)
        # Assuming an average water temp of 20C, see Froese & Pauly 2000 in Martinez-Andrade 2003
        Mnat <- 10^(0.566-(0.718*log10(spx$linf))+0.02*20)

        VBG_K <- (Mnat*spx$lopt)/(3*(spx$linf-spx$lopt))
        VBG_K2 <- 2.15*(spx$linf^-0.46)

        if(var(dfx$cm) > 0 & nrow(dfx) >= 50) {

            # Calculate the mode of the LFD, using 5 cm bins
            dfx$cm_bin5 <- 5*round(dfx$cm/5)
            tmp <- table(as.vector(dfx$cm_bin5))
            lc <- as.numeric(names(tmp)[tmp==max(tmp)])

            d1 <- bheq2(len = dfx$cm, Linf = spx$linf, K = VBG_K, Lc = lc[1], La = spx$linf,nboot = 200)

            # Calculate SPR from growth parameters and Z, and M

            d1$Mnat <- Mnat

            # Generate vector with ages 1-100
            age <- 1:100
            popdf <- data.frame(age)
            popdf$popF0 <- 1000*exp(-Mnat*age)
            # Calculate mean length for each age
            popdf$TL <- spx$linf*(1-exp(-VBG_K*age))
            # Note: the following disregards that a's and b's were sometimes for FL instead of TL
            popdf$BW <- spx$var_a*popdf$TL^spx$var_b
            popdf$BiomassF0 <- popdf$BW * popdf$popF0
            popdf$Mature <- ifelse(popdf$TL < spx$lmat,0,1)
            popdf$SpBiomassF0 <- popdf$BiomassF0*popdf$Mature
            SpBiomassF0 <- sum(popdf$SpBiomassF0)
                    BiomassF0 <- sum(popdf$BiomassF0)

            # Calculate F, assume that recruitment to the fishery starts at the 1st percentile in the LFD,
            # then increases linearly up to Lc
            lc_sub <- quantile(dfx$cm, c(.01), names=FALSE)
            Fmax <- d1$Z-Mnat

            # F increases linearly with length from 0 at lc_sub until Fmax at lc
            #popdf$Fact <- cases(
                #"0" = popdf$TL < lc_sub,
                #"(popdf$TL*Fmax/(lc-lc_sub))-(lc_sub*Fmax/(lc-lc_sub))" = popdf$TL < lc,
                #"Fmax" = TRUE)

            popdf$Fact <- ifelse(popdf$TL < lc_sub,0,
                         ifelse(popdf$TL < lc & popdf$TL>= lc_sub,(popdf$TL*Fmax/(lc-lc_sub))-(lc_sub*Fmax/(lc-lc_sub)),Fmax))

            popdf$popFact[1] <- 1000*exp(-(Mnat+popdf$Fact[1])*1)
            for(i in 2:100){
                popdf$popFact[i] <- popdf$popFact[i-1]*exp(-(Mnat+popdf$Fact[i])*1)
            }

            popdf$BiomassFact <- popdf$BW * popdf$popFact
            popdf$SpBiomassFact <- popdf$BiomassFact*popdf$Mature
            SpBiomassFact <- sum(popdf$SpBiomassFact)
            BiomassFact <- sum(popdf$BiomassFact)
            SPR <- SpBiomassFact/SpBiomassF0
            BoverB0 <- BiomassFact/BiomassF0
            perc_spr <- 100 * SPR
            perc_BoverB0 <- 100*BoverB0
            ratio_FvsM <- Fmax/Mnat

            if(perc_spr < 100) {
                text_spr <- paste(formatC(perc_spr,digits=0,format="f"),sep=" ")
            } else {
                perc_spr <- 100
                text_spr <- paste("near 100")
            }

            if(perc_BoverB0 < 100) {
                text_BoverB0 <- paste(formatC(perc_BoverB0,digits=0,format="f"),sep=" ")
            } else {
                text_BoverB0 <- paste("near 100")
            }

            if(ratio_FvsM > 0) {
                text_FvsM <- paste(formatC(ratio_FvsM,digits=2,format="f"),sep=" ")
            } else if(ratio_FvsM == 0) {
                text_FvsM <- paste("unknown")
            } else {
                text_FvsM <- paste("near 0")
            }

        }
        #### SPR END HERE

        #add conclusion value on list
        #spx$perc_imm <- perc_imm
        #spx$val_mst <- (spx$plotted_trade_limit_tl / spx$lmat)
        #spx$perc_cel <- (perc_imm + perc_smat)
        #spx$perc_megasp <- perc_megasp
        #spx$ratio_FvsM <- text_FvsM
        #spx$text_spr <- text_spr
        #spx$perc_smat <- perc_smat
        #spx$perc_lmat <- perc_lmat
        #spx$perc_yopt <- perc_yopt
        #spx$perc_spr <- perc_spr
        #spx$perc_BoverB0 <- text_BoverB0
        #spx$VBG_K2 <- VBG_K2
        spx$lc <- lc[1]
        spx$lc_sub <- lc_sub
        spx$Fmax <- Fmax
        spx$Mnat <- Mnat
        spx$VBG_K <- VBG_K
    }
	
    # add species with conclusion into new data frame
    dfResult <- rbind(dfResult, spx)
}

names(dfResult) <- c("#ID", "Family", "Genus", "Species", "Lmat", "Lopt", "Linf", "Lmax", "Var_a", "Var_b", "SampleSize", "Lc", "LcSub", "Fmax", "Mnat", "VBG_K")
WriteXLS("dfResult", "/root/app/ifish/pub/IFishEstimatedParameters.xls", "Data", BoldHeaderRow=TRUE, FreezeRow=1)
