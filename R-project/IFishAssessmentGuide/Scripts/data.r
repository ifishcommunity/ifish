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
rs <- dbSendQuery(con1, "select f.fish_id, lmat, lmatm, lopt, linf, lmax, landing_date, cm, b.name as boat, approach from ifish_fish f inner join ifish_sizing s on f.oid = s.fish_id inner join ifish_deepslope d on s.landing_id = d.oid inner join ifish_boat b on d.boat_id = b.oid where f.fish_id > 0 and s.data_quality = 1 and ((d.approach = 0 and d.landing_date < '2015-10-06') or (d.approach = 2 and d.landing_date >= '2015-10-06')) and fishery_type = any(values('Snapper')) and doc_status = any(values('Posted'));")
dbHasCompleted(rs) # TRUE if all records have been fetched from the database
df <- fetch(rs, n = -1)
df$EcoSize <- cases("Immature" = df$cm<df$lmat, "SmallMature" = df$cm<=df$lopt, "LargeMature" = df$cm<df$lopt*1.1, "MegaSpawner" = TRUE)


# Quering all species 
rs2 <- dbSendQuery(con1, paste("select * from (select f.fish_id, f.fish_family, f.fish_genus, f.fish_species, f.lmat, f.lopt, f.linf, f.lmax, f.largest_specimen_cm, var_a, var_b, plotted_trade_limit_tl, count(s.*) as n from ifish_fish f inner join ifish_sizing s on f.oid = s.fish_id inner join ifish_deepslope d on s.landing_id = d.oid where f.fish_id > 0 and s.data_quality = 1 and ((d.approach = 0 and d.landing_date < '2015-10-06') or (d.approach = 2 and d.landing_date >= '2015-10-06')) and fishery_type = any(values('Snapper')) and doc_status = any(values('Posted')) group by 1,2,3,4,5,6,7,8,9,10,11,12) as t1 order by n desc;", sep=""))
dbHasCompleted(rs2) # TRUE if all records have been fetched from the database
SPP <- fetch(rs2, n = -1)
SPP$fish_binary <- paste(SPP$fish_genus,SPP$fish_species, sep=' ')

# Quering Top 50 species bigest sample size in CODRS
rs3 <- dbSendQuery(con1, paste("select * from (select f.fish_id, f.fish_family, f.fish_genus, f.fish_species, f.lmat, f.lopt, f.linf, f.lmax, f.largest_specimen_cm, var_a, var_b, plotted_trade_limit_tl, count(s.*) as n from ifish_fish f inner join ifish_sizing s on f.oid = s.fish_id inner join ifish_deepslope d on s.landing_id = d.oid where f.fish_id > 0 and s.data_quality = 1 and ((d.approach = 0 and d.landing_date < '2015-10-06') or (d.approach = 2 and d.landing_date >= '2015-10-06')) and fishery_type = any(values('Snapper')) and doc_status = any(values('Posted')) group by 1,2,3,4,5,6,7,8,9,10,11,12) as t1 order by n desc limit 50 offset 0;", sep=""))
dbHasCompleted(rs3) # TRUE if all records have been fetched from the database
SPP2 <- fetch(rs3, n = -1)
SPP2$fish_binary <- paste(SPP2$fish_genus,SPP2$fish_species, sep=' ')
SPP2$fish_rank <- paste("0", sep=' ')

knit('/root/R-project/IFishAssessmentGuide/Scripts/IFishAssessmentGuide.Rnw',output='/root/R-project/IFishAssessmentGuide/Scripts/IFishAssessmentGuide.tex')
