rm(list=ls())
args <- commandArgs(TRUE)

if(length(args) == 0){
  warning("args is missing")
}else{
  start <- as.numeric(args)
}
timestart <- Sys.time()
library(raster)
library(dplyr)

depth_bedrock <- raster("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Depth_To_Bedrock_Water.asc")
depth_bedrock[is.na(depth_bedrock)]<- -9
Soildata <- as.data.frame(rasterToPoints(depth_bedrock))

Soildata$rowID <- row.names(Soildata)

startindex <- (start-1) * 10000 + 1
endindex <- start*10000

if(endindex>21812625){
  endindex <- 21812625
}

originalsoil_output<- Soildata[startindex:endindex,]

outputdataframe <- data.frame(x=numeric(0),y=numeric(0),layer.1=numeric(0),layer.2=numeric(0),rowID=numeric(0),ClimateIndex=numeric(0),UniqueSimulation=numeric(0),Yieldmean=numeric(0),YieldSD=numeric(0))

for (fileindex in 1:114){
biocrooutput<- paste("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Results/formatted",fileindex,".RData",sep="")
load(biocrooutput)
outputdataframe <- rbind(outputdataframe,Soildata_UniqueClimate)
}

originalsoil_output$Yieldmean <- NA
originalsoil_output$YieldSD <- NA

N <- dim(originalsoil_output)[1]

timestartloop <- Sys.time()

for(i in 1:N){
rowID <- originalsoil_output$rowID[i]
matchedID <- which(outputdataframe$rowID %in% rowID)
if(length(matchedID)==1){
originalsoil_output$Yieldmean[i] <- outputdataframe$Yieldmean[matchedID]
originalsoil_output$YieldSD[i] <-  outputdataframe$YieldSD[matchedID]
}else{
originalsoil_output$Yieldmean[i] <- NA
originalsoil_output$YieldSD[i] <-  NA
}
}


outputfile <- paste("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Results/OriginalSoilOutput",start,".RData",sep="")
save(originalsoil_output,file=outputfile)
timeend <- Sys.time()
timestart
timeend  
timestartloop


