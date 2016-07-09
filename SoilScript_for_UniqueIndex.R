rm(list=ls())
args <- commandArgs(TRUE)

if(length(args) == 0){
  warning("args is missing")
}else{
  start <- as.numeric(args)
}
library(dplyr)
startindex <- (start-1) * 100000 + 1
endindex <- start*100000
if(endindex>11341510){
  endindex <- 11341510
}

filename <- paste("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Intermediate_Soil/",start,".Rdata",sep="")
load(filename)

tmp <- group_by(Soildata_UniqueClimate,UniqueSimulation)
Soildata_UniqueSimulations <- summarise(tmp,lat= mean(y,na.rm=TRUE),lon=mean(x,na.rm=TRUE), SoilDepth=mean(layer.1,na.rm=TRUE),SoilType=max(layer.2,na.rm=TRUE))
Soildata_UniqueSimulations$SoilDepth <- Soildata_UniqueSimulations$SoilDepth/100 # Cm to m conversion
outputfile <- paste("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Intermediate_Soil/UniqueID",start,".Rdata",sep="")
save(Soildata_UniqueSimulations,file=outputfile)