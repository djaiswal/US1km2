rm(list=ls())
args <- commandArgs(TRUE)

if(length(args) == 0){
  warning("args is missing")
}else{
  start <- as.numeric(args)
}

library(raster)
library(dplyr)

stemindex <- numeric(32)
stemindex[1] <- 12
for (i in 2:32){
  stemindex[i] <- stemindex[i-1]+7
}

Ratoonfactors <- c(1,1.2,0.7,0.6) # 4 years
Multiplyingfactor <- mean(Ratoonfactors)

Resultfilename <- paste("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Results/",start,".RData",sep="")
load(Resultfilename)
N<- dim(finaloutput)[1]
Output <- data.frame(UniqueSimulationID=numeric(0),StemYield=numeric(0))
UniqueOutPut <- data.frame(UniqueSimulationID=numeric(32),StemYield=numeric(32))

for( j in 1:N)
{
  tmp <- finaloutput[j:j,]
  UniqueOutPut$UniqueSimulationID[1:32] <- tmp[5]
  UniqueOutPut$StemYield <- as.vector(as.numeric(c(tmp[stemindex[1]],tmp[stemindex[2]],tmp[stemindex[3]],tmp[stemindex[4]],tmp[stemindex[5]],tmp[stemindex[6]],tmp[stemindex[7]],
                                                   tmp[stemindex[8]],tmp[stemindex[9]],tmp[stemindex[10]],tmp[stemindex[11]],tmp[stemindex[12]],tmp[stemindex[13]],tmp[stemindex[14]],
                                                   tmp[stemindex[15]],tmp[stemindex[16]],tmp[stemindex[17]],tmp[stemindex[18]],tmp[stemindex[19]],tmp[stemindex[20]],tmp[stemindex[21]],
                                                   tmp[stemindex[22]],tmp[stemindex[23]],tmp[stemindex[24]],tmp[stemindex[25]],tmp[stemindex[26]],tmp[stemindex[27]],tmp[stemindex[28]],
                                                   tmp[stemindex[29]],tmp[stemindex[30]],tmp[stemindex[31]],tmp[stemindex[32]]))) 
  Output <- rbind(Output,UniqueOutPut)
}
Output$StemYield <- Output$StemYield*Multiplyingfactor

tmp <- group_by(Output,UniqueSimulationID)
UniqueOutput <- summarise(tmp,Yieldmean=mean(StemYield),YieldSD=sd(StemYield))
filename <-  paste("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Results/YieldandCV",start,".RData",sep="")
save(UniqueOutput,file=filename)



validsoilfile <- paste("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Intermediate_Soil/",start,".Rdata",sep="")
load(validsoilfile)
Soildata_UniqueClimate$Yieldmean <- NA
Soildata_UniqueClimate$YieldSD <- NA
N <- dim(Soildata_UniqueClimate)[1]


for ( i in 1:N){
  currentrow <- Soildata_UniqueClimate$UniqueSimulation[i]
  matchedrow <- which(UniqueOutput$UniqueSimulationID %in% currentrow)
  if(length(matchedrow)==1) {
    Soildata_UniqueClimate$Yieldmean[i] <- UniqueOutput$Yieldmean[matchedrow]
    Soildata_UniqueClimate$YieldSD[i] <- UniqueOutput$YieldSD[matchedrow]
  } else{
    print(matchedrow)
    error("now unique matched occured")
  }
}

filetosave<- paste("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Results/formatted",start,".RData",sep="")
save(Soildata_UniqueClimate,file=filetosave)

