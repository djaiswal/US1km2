rm(list=ls())
args <- commandArgs(TRUE)

if(length(args) == 0){
  warning("args is missing")
}else{
  start <- as.numeric(args)
}
#Loading BioCro
library(BioCro,lib.loc="/home/a-m/djaiswal/R/library")
#Function to get NARR data
source("/home/a-m/djaiswal/Scripts/ClimateProcessing/NARR/getNARRforBioCro.R")


iRhizome <- 6
Co2level=380
day1=15 #15 January
dayn=349 # 15 December
startyear=1979
endyear=2010
harvestduration=7

soilfilename <- paste("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Intermediate_Soil/UniqueID",start,".Rdata",sep="")
load(soilfilename)
N <- dim(Soildata_UniqueSimulations)[1]
Soildata_UniqueSimulations
ii=1
jj=1
finaloutput <- NULL
for ( i in 1:N){
    currentyear <- startyear
    output <- NULL
    Tmin <- Soildata_UniqueSimulations$UniqueSimulation[i]
    repeat{
        if(currentyear>endyear){
            break}
      dat<- NULL
      lat <-Soildata_UniqueSimulations$lat[i]
      lon <- Soildata_UniqueSimulations$lon[i]
      soilDepth <- Soildata_UniqueSimulations$SoilDepth[i]
      SoilType <-  Soildata_UniqueSimulations$SoilType[i]
     
      dat <- getNARRforBioCro(lat,lon,currentyear)
      soilP <- soilParms(wsFun="logistic",phi1=0.0177,phi2=0.83,rfl=0.4,soilLayers=1,soilDepth=soilDepth,soilType=SoilType)
      res1<- caneGro(dat,lat=lat, soilControl=soilP,photoControl=list(Catm=Co2level),day1 = day1, dayn = dayn,iRhizome=iRhizome,irtl=1e-2)
      stem1<-res1$Stem[length(res1$Stem)]
      leaf1<-res1$Leaf[length(res1$Leaf)]
      root1 <-res1$Root[length(res1$Root)]
      Seedcane1 <- res1$Seedcane[length(res1$Seedcane)]
      leaflitter1<- res1$LeafLittervec[length(res1$LeafLittervec)]
      tmpoutput<-as.vector(c(currentyear,stem1, leaf1,root1,Seedcane1,leaflitter1))
      output<-as.vector(c(output,tmpoutput))
      output<-as.vector(c(output,stem1*0.89)) # we still need to save output because sugarca
      currentyear<-currentyear+1
    } #end repeat
    gridoutput<-as.vector(c(c(ii,jj,lat,lon,Tmin),output))
    finaloutput <- rbind(finaloutput,gridoutput)
} # end main for loop
   save(finaloutput,file=paste("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Results/",start,".RData",sep=""))

timeend <- Sys.time()
timestart
timeend
object.size(finaloutput)
        

        
        
        
        







