
library(data.table)
library(plyr)
library(rjson)
library(reshape)

#rm(list=ls(), envir = globalenv())

####
####
data.directory <- "~/work/hackaton/MassDOThack.data"

## MBCR_Rail_Volume
subdirectory <- "/MBCR_Rail_Volume"
setwd(sprintf("%s%s", data.directory, subdirectory))
y11 <- data.table(read.csv("MBCR_Trip_Records_2011.csv"))
y12 <- data.table(read.csv("MBCR_Trip_Records_2012.csv"))
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
                                    "%m/%d/%Y %I:%M:%S %p")),
                      cSchArvTm = as.POSIXct(strptime(
                                    sprintf("%s %s", summary.y13$tTrip, summary.y13$cSchArvTm), 
                                    "%m/%d/%Y %I:%M:%S %p")),
                      cActDptTm = as.POSIXct(strptime(
                                    sprintf("%s %s", summary.y13$tTrip, summary.y13$cActDptTm), 
                                    "%m/%d/%Y %I:%M:%S %p")),
                      cActArvTm = as.POSIXct(strptime(
                                    sprintf("%s %s", summary.y13$tTrip, summary.y13$cActArvTm), 
                                    "%m/%d/%Y %I:%M:%S %p")),
                      delay = cSchArvTm - cActArvTm)

#        as.POSIXct(strptime(
#sprintf("%s %s", summary.y13$tTrip[1], summary.y13$cSchDptTm[1]), 
#              "%m/%d/%Y %H:%M:%S %p"))
           
#with(summary.y13, as.POSIXct(sprintf("%s %s", tTrip[1], cSchDptTm[1])))                
#for (i in 1:length(summary.y13$cSchDptTm)){
#  print(i)
#as.POSIXct(summary.y13$cSchDptTm)
#}

all.locations1.vec <- unique(summary.y13$ActualDepartureLocation)
all.locations2.vec <- unique(summary.y13$ActualArrivalLocation)
all.locations.vec <- union(all.locations1.vec, all.locations2.vec)



#upper.t.target <- timestamp.target + 1
#which(summary.y13$cSchArvTm > timestamp.target)
#which(as.double(difftime(timestamp.target, summary.y13$cSchDptTm, units="mins") ) < 10)
#time.mins.interval <- 100


date.target <- c("10/22/2013")
time.target <- c("9:00 AM") 
timestamp.target <- as.POSIXct(strptime(
  sprintf("%s %s", date.target, time.target),  "%m/%d/%Y %H:%M %p"))


line.names.vec <- unique(summary.y13$Route)
aaa <- data.table(ldply(line.names.vec, function(line.name){
  target.df <- summary.y13[Route==line.name,]
  indexes <- which( (as.double(difftime(timestamp.target, target.df$cSchDptTm, units="mins") ) > 0) & 
                    (as.double(difftime(timestamp.target, target.df$cSchArvTm, units="mins") ) < 0 ))
  return(data.frame(Route=line.name, n_passenger = sum(target.df$iPassenger[indexes]) ) )
}))


date.target <- c("10/22/2013")
time.target <- c("16:00")
timestamp.target <- as.POSIXct(strptime(
  sprintf("%s %s", date.target, time.target),  "%m/%d/%Y %H:%M"))

  

get.passanger.df <- function(date.target, time.target){
  timestamp.target <- as.POSIXct(strptime(
    sprintf("%s %s", date.target, time.target),  "%m/%d/%Y %H:%M"))

  line.names.vec <- unique(summary.y13$Route)
  aaa <- data.table(ldply(line.names.vec, function(line.name){
    target.df <- summary.y13[Route==line.name,]
    indexes <- which( (as.double(difftime(timestamp.target, target.df$cSchDptTm, units="mins") ) >= 0) & 
                        (as.double(difftime(timestamp.target, target.df$cSchArvTm, units="mins") ) <= 0 ))
    return(data.frame(Route=line.name, n_passenger = sum(target.df$iPassenger[indexes]) ) )
  }))
  return(aaa)
}

date.target <- c("10/22/2013")
time.target <- c("16:00")
get.passanger.df(date.target, time.target)

get.passanger.timestamps.df <- function(timestamp.target){
  line.names.vec <- unique(summary.y13$Route)
  aaa <- data.table(ldply(line.names.vec, function(line.name){
    target.df <- summary.y13[Route==line.name,]
    indexes <- which( (as.double(difftime(timestamp.target, target.df$cSchDptTm, units="mins") ) >= 0) & 
                        (as.double(difftime(timestamp.target, target.df$cSchArvTm, units="mins") ) <= 0 ))
    return(data.frame(Route=line.name, n_passenger = sum(target.df$iPassenger[indexes]) ) )
  }))
  return(aaa)
}


timestampToUnix <- function(timestamp.ttt){
  date.target <- c("1/1/1970")
  time.target <- c("00:00")
  timestamp.aux<- as.POSIXct(strptime(
    sprintf("%s %s", date.target, time.target),  "%m/%d/%Y %H:%M"))
  
  res <- as.double(difftime(timestamp.ttt, timestamp.aux, units="secs"))
  return(res)
}


date.target <- c("11/04/2012")
time.target <- c("22:32")
timestamp.ttt <- as.POSIXct(strptime(
  sprintf("%s %s", date.target, time.target),  "%m/%d/%Y %H:%M"))

#2012-11-04 22:32:00
#timestampToUnix(timestamp.ttt)


date.target <- c("1/1/2013")
time.target <- c("00:00")
timestamp.target.init <- as.POSIXct(strptime(
  sprintf("%s %s", date.target, time.target),  "%m/%d/%Y %H:%M"))

date.target <- c("1/3/2013")
time.target <- c("24:00")
timestamp.target.final <- as.POSIXct(strptime(
  sprintf("%s %s", date.target, time.target),  "%m/%d/%Y %H:%M"))


increment.time <- as.difftime(60, units="mins")

timestamp.target <- timestamp.target.init
res.final.df <- data.frame()
while(timestamp.target < timestamp.target.final){
  res.df <- get.passanger.timestamps.df(timestamp.target)
  n_sec <- timestampToUnix(timestamp.target)
  res.df$unix_time <- n_sec
  res.df$time <- timestamp.target
  res.final.df <- rbind(res.final.df, cast(res.df, unix_time ~ Route , mean, value='n_passenger'))
  timestamp.target <- timestamp.target + increment.time
}

##############
##############


date.target <- c("10/7/2013")
time.target <- c("00:00")
timestamp.target.init <- as.POSIXct(strptime(
  sprintf("%s %s", date.target, time.target),  "%m/%d/%Y %H:%M"))

date.target <- c("10/13/2013")
time.target <- c("24:00")
timestamp.target.final <- as.POSIXct(strptime(
  sprintf("%s %s", date.target, time.target),  "%m/%d/%Y %H:%M"))


increment.time <- as.difftime(60, units="mins")

timestamp.target <- timestamp.target.init
res.final.df <- data.frame()
while(timestamp.target < timestamp.target.final){
  print(timestamp.target)
  timestamp.aux <- timestamp.target
  timestamp.aux.final <-  timestamp.target + increment.time
  res.aux.df <- data.frame()
  while(timestamp.aux < timestamp.aux.final){
    res.df <- get.passanger.timestamps.df(timestamp.aux)
    n_sec <- timestampToUnix(timestamp.target)
    res.df$unix_time <- n_sec
    res.aux.df <- rbind(res.aux.df, res.df)
    timestamp.aux <- timestamp.aux + increment.time/4
  }
  res.final.df <- rbind(res.final.df, cast(res.aux.df, unix_time ~ Route , mean, value='n_passenger'))
  timestamp.target <- timestamp.target + increment.time
}


data.directory <- "~/work/hackaton/MassDOThack"
subdirectory <- ""
setwd(sprintf("%s%s", data.directory, subdirectory))
write.csv(res.final.df, file="passengers.lines.csv")
      
      
      
      
      
      
      
      







