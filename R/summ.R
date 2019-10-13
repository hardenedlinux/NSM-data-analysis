data(dietox)
dietox12    <- subset(dietox,dietox$Time==12)summaryBy(Weight+Feed~Evit+Cu,      data=dietox12, FUN=c(mean,var), na.rm=TRUE)  

summaryBy(Weight+Feed~Evit+Cu+Time, data=subset(dietox,Time>1),
FUN=c(mean,var), na.rm=TRUE)  

summaryBy(Weight+Feed~Evit+Cu,      data=dietox12, FUN=length)  

summaryBy(log(Weight)+Feed~Evit+Cu,      data=dietox12)  
summaryBy(.~Evit+Cu,      data=dietox12, id=~Litter, FUN=mean)

data(warpbreaks)
summaryBy(breaks ~ wool+tension, warpbreaks)
summaryBy(breaks ~., warpbreaks)
summaryBy(.~ wool+tension, warpbreaks)

summaryBy(Ozone~Month, data=airquality,FUN=c(mean,var),na.rm=TRUE)

summaryBy(Ozone+Wind~Month, data=airquality,FUN=c(mean),na.rm=TRUE,
  keep.names=TRUE)

summaryBy(Ozone+Wind~Month, data=airquality,FUN=c(mean,var),na.rm=TRUE,
  postfix=c("m","v"))

summaryBy(Ozone+Wind~Month, data=airquality,
  FUN=c(function(x,...){c(mean(x,...),var(x,...))},function(x,...){median(x,...)}),
  postfix=list(c("m","v"),"med"), na.rm=TRUE)


summaryBy(conc ~ Plant, CO2)

do.call("summaryBy", list(.~ Treatment, CO2[3:5], FUN = function(x) mean(range(x)), postfix = "midrange"))
