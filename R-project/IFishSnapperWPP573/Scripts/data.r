#!/usr/bin/Rscript
# file: a1.r
# purpose:
# by: Peter Mous [pjmous@gmail.com], Gede Wawan [gede.wawan@gmail.com]
# date first version: 9 September 2013
# date this version:
# requires:

# load packages
library(Hmisc)
library(doBy)

library(foreign)
library(reshape2)
library(gdata) # requires Perl
library(ggplot2)
library(knitr)
library(xtable)
library(RPostgreSQL)
library(R2HTML)
library(memisc)
library(gmodels)
library(RcppEigen, lib.loc="/root/R-project/lib/")
library(lme4, lib.loc="/root/R-project/lib/")
library(bootstrap, lib.loc="/root/R-project/lib/")
library(fishmethods, lib.loc="/root/R-project/lib/")
library(stargazer, lib.loc="/root/R-project/lib/")

# remove all objects
rm(list=ls())

# Start postgres with $sudo systemctl start postgresql
# create a PostgreSQL instance and create one connection.
m <- dbDriver("PostgreSQL")
con1 <- dbConnect(m, user="postgres", password="postgres", dbname="ifish_community")

# Quering data of sizing
rs <- dbSendQuery(con1, "select f.fish_id, lmat, lmatm, lopt, linf, lmax, landing_date, cm, b.name as boat, approach from ifish_fish f inner join ifish_sizing s on f.oid = s.fish_id inner join ifish_deepslope d on s.landing_id = d.oid inner join ifish_boat b on d.boat_id = b.oid where ((d.approach = 0 and d.landing_date < '2015-10-06') or (d.approach = 2 and d.landing_date >= '2015-10-06')) and f.fish_id > 0 and s.data_quality = 1 and (d.wpp1 = any(values('573')) or d.wpp2 = any(values('573')) or d.wpp3 = any(values('573'))) and fishery_type = any(values('Snapper')) and doc_status = any(values('Posted'));")
dbHasCompleted(rs) # TRUE if all records have been fetched from the database
df <- fetch(rs, n = -1)
df$EcoSize <- cases("Immature" = df$cm<df$lmat, "SmallMature" = df$cm<=df$lopt, "LargeMature" = df$cm<df$lopt*1.1, "MegaSpawner" = TRUE)


# Quering 50 biggest species specimen from SM and CODRS in current year - 1
n <- 50
where <- paste0("")
currentYear <- as.numeric(format(Sys.time(), "%Y"))
if(currentYear-1 == 2015) {
where <- paste(" ((d.approach = 0 and d.landing_date >= '2015-01-01' and d.landing_date < '2015-10-06') or (d.approach = 2 and d.landing_date >= '2015-10-06' and d.landing_date <= '2015-12-31')) and f.fish_id > 0 and s.data_quality = 1 and (d.wpp1 = any(values('573')) or d.wpp2 = any(values('573')) or d.wpp3 = any(values('573'))) and fishery_type = any(values('Snapper')) and doc_status = any(values('Posted'))", sep="")
} else {
where <- paste(" d.approach = 2 and d.landing_date >= '", currentYear-1, "-01-01' and d.landing_date <= '", currentYear-1, "-12-31' and f.fish_id > 0 and s.data_quality = 1 and (d.wpp1 = any(values('573')) or d.wpp2 = any(values('573')) or d.wpp3 = any(values('573'))) and fishery_type = any(values('Snapper')) and doc_status = any(values('Posted'))", sep="")
}

rs2 <- dbSendQuery(con1, paste("select * from (select f.fish_id, f.fish_family, f.fish_genus, f.fish_species, f.lmat, f.lopt, f.linf, f.lmax, f.plotted_trade_limit_tl, f.reported_trade_limit_weight, f.var_a, f.var_b, f.length_basis, f.converted_trade_limit_l, count(s.*) as n from ifish_fish f inner join ifish_sizing s on f.oid = s.fish_id inner join ifish_deepslope d on s.landing_id = d.oid where", where, " group by f.fish_id, f.fish_family, f.fish_genus, f.fish_species, f.lmat, f.lopt, f.linf, f.lmax, f.plotted_trade_limit_tl, f.reported_trade_limit_weight, f.var_a, f.var_b, f.length_basis, f.converted_trade_limit_l ) as t1 order by n desc limit ", n, " offset 0;", sep=""))
dbHasCompleted(rs2) # TRUE if all records have been fetched from the database
SPP <- fetch(rs2, n = -1)
SPP$fish_binary <- paste(SPP$fish_genus,SPP$fish_species, sep=' ')

knit('/root/R-project/IFishSnapperWPP573/Scripts/IFishSnapperWPP573.Rnw',output='/root/R-project/IFishSnapperWPP573/Scripts/IFishSnapperWPP573.tex')
