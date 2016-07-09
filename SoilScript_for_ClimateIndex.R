rm(list=ls())
args <- commandArgs(TRUE)

if(length(args) == 0){
  warning("args is missing")
}else{
  start <- as.numeric(args)
}


load("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Soildata_valid.Rdata")
startindex <- (start-1) * 100000 + 1
endindex <- start*100000
#Limiting by size of Soildata_valid
if(endindex>11341510){
  endindex <- 11341510
}

Soildata_UniqueClimate <- Soildata_valid[startindex:endindex,]
N <- endindex -startindex + 1
for (i in 1:N) {
  USlayer<-read.table("/home/groups/ebimodeling/met/NARR/ProcessedNARR/NARRindex.txt")
  lat <-Soildata_UniqueClimate$y[i]
  lon <-Soildata_UniqueClimate$x[i]
  index=which.min((lat-USlayer$Latt)^2+(lon-USlayer$Lonn)^2)
  Soildata_UniqueClimate$ClimateIndex[i]=index
  Soildata_UniqueClimate$UniqueSimulation[i] <- paste(Soildata_UniqueClimate$layer.1[i],Soildata_UniqueClimate$layer.2[i],Soildata_UniqueClimate$ClimateIndex[i],sep="")
}
save(Soildata_UniqueClimate,file=paste("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Intermediate_Soil/",start,".Rdata",sep=""))