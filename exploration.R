
library(data.table)
library(plyr)
####
####
data.directory <- "~/work/hackaton/MassDOThack.data"

## MBCR_Rail_Volume
subdirectory <- "/MBCR_Rail_Volume"
setwd(sprintf("%s%s", data.directory, subdirectory))
y11 <- data.table(read.csv("MBCR_Trip_Records_2013.csv"))
y12 <- data.table(read.csv("MBCR_Trip_Records_2013.csv"))
y13 <- data.table(read.csv("MBCR_Trip_Records_2013.csv"))

## MBCR_Rail_Locations
subdirectory <- "/MBCR_Rail_Locations"
setwd(sprintf("%s%s", data.directory, subdirectory))
l0813 <- data.table(read.csv("VehMS_12-08-2013.csv"))

vehicles.vec <- unique(l0813$Vehicle_ID)
l_ply(vehicles.vec, function(x){
              print(dim(l0813[Vehicle_ID==x]))
              print()
              })

sample.df <- data.table(l0813[Vehicle_ID=='1505'])
sample2.df <- data.table(l0813[Vehicle_ID=='1520'])















