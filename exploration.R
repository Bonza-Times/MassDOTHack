
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
l0713 <- data.table(read.csv("VehMS_12-07-2013.csv")) 
l0613 <- data.table(read.csv("VehMS_12-06-2013.csv"))

vehicles.vec <- unique(l0813$Vehicle_ID)
l_ply(vehicles.vec, function(x){
              print(dim(l0813[Vehicle_ID==x]))
              print()
              })

sample.df <- data.table(l0813[Vehicle_ID=='1505'])
sample2.df <- data.table(l0813[Vehicle_ID=='1520'])

## line and station data
subdirectory <- "/Stations"
setwd(sprintf("%s%s", data.directory, subdirectory))
lines.df <- data.table(read.csv("StationOrder.csv"))


## join Volume and Locations

## work on the getting the density and volume of stations

summary.y13 <- y13[ , c(
"Route", ## Route 
"Direction", ## Outward/Inward
"tTrip", ## trip date
"ActualDepartureLocation",
"ActualArrivialLocation",
"cSchDptTm", ##Schedule Departure time (in String Format),1:00:00 AM
"cSchArvTm", ##Schedule Arrivial time (in String Format),2:05:00 AM
"cActDptTm", ## Actual Departure time (in String Format),1:00:00 AM
"cActArvTm",  ## Actual Arrivial time (in String Format),2:26:00 AM
"iPassenger", ## passanger count
"iCapReq"    ## required capacity
), with=FALSE]

summary.y13 <- mutate(summary.y13, 
                      cSchDptTm = as.POSIXct(strptime(
                                    sprintf("%s %s", summary.y13$tTrip, summary.y13$cSchDptTm), 
                                    "%m/%d/%Y %H:%M:%S %p")),
                      cSchArvTm = as.POSIXct(strptime(
                                    sprintf("%s %s", summary.y13$tTrip, summary.y13$cSchDptTm), 
                                    "%m/%d/%Y %H:%M:%S %p")),
                      cActDptTm = as.POSIXct(strptime(
                                    sprintf("%s %s", summary.y13$tTrip, summary.y13$cSchDptTm), 
                                    "%m/%d/%Y %H:%M:%S %p")),
                      cActArvTm = as.POSIXct(strptime(
                                    sprintf("%s %s", summary.y13$tTrip, summary.y13$cSchDptTm), 
                                    "%m/%d/%Y %H:%M:%S %p")),
                      delay = cSchArvTm - cActArvTm)

        as.POSIXct(strptime(
              sprintf("%s %s", summary.y13$tTrip[1], summary.y13$cSchDptTm[1]), 
              "%m/%d/%Y %H:%M:%S %p"))
           
with(summary.y13, as.POSIXct(sprintf("%s %s", tTrip[1], cSchDptTm[1])))                
for (i in 1:length(summary.y13$cSchDptTm)){
  print(i)
  as.POSIXct(summary.y13$cSchDptTm)
}

all.locations1.vec <- unique(summary.y13$ActualDepartureLocation)
all.locations2.vec <- unique(summary.y13$ActualArrivalLocation)
all.locations.vec <- union(all.locations1.vec, all.locations2.vec)


