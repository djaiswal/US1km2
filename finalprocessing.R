
for ( i in 1:2182){
  outputfile <- paste("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Results/OriginalSoilOutput",i,".RData",sep="")
  load(outputfile)
  if(i==1){
    output <- originalsoil_output
  } else
  {
  output <- rbind(output,originalsoil_output)
  }
}
filename <- paste("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Results/output_to_plot.RData",sep="")

save(output,file=filename)

library(raster)
library(dplyr)

Yieldmeandataframe <- output[,c("x","y","Yieldmean")]
YieldSDdatafreame <- output[,c("x","y","YieldSD")]



Yieldmeanraster <- rasterFromXYZ(Yieldmeandataframe)
writeRaster(Yieldmeanraster, filename="/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Results/Yieldmean.asc", datatype='ascii')
YieldSDraster <- rasterFromXYZ(YieldSDdatafreame)
writeRaster(YieldSDraster, filename="/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Results/YieldSD.asc", datatype='ascii')
