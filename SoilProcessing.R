library(raster)
library(dplyr)

# Step  1
# Reading Original Soil Data and Creating a necessary data frame after unit conversion

depth_bedrock <- raster("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Depth_To_Bedrock_Water.asc")
layer0to5 <- raster("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/soil1.asc")
layer5to10 <- raster("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/soil2.asc")
layer10to20 <- raster("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/soil3.asc")

# There is not much difference between 0-5, 5-10, and 10-20 cm soil texture' therefore I am simply going to use data from layer0to5 as soil texture.
depth_bedrock[is.na(depth_bedrock)]<- -9

#Replacing layer0to5 by mode of the layers from 0 to 20
Mode <- function(x) {
  ux <- unique(x)
  ux=ux[!is.na(ux)]
  ux[which.max(tabulate(match(x, ux)))]
}
layer <- stack(layer0to5,layer5to10,layer10to20)
layer0to5 <- calc(layer,fun=Mode)


#Changing Soil type to be consistent with BioCro denfition (showSoiType function in BioCro R package)
#########
layer0to5[((layer0to5==0)|(layer0to5==13)|(layer0to5==14)|(layer0to5==15)|(layer0to5==16))]<- -9
layer0to5[layer0to5==1]<- 0
layer0to5[layer0to5==2]<- 1
layer0to5[layer0to5==3]<- 2
layer0to5[layer0to5==4]<- 4
layer0to5[layer0to5==5]<- 4
layer0to5[layer0to5==6]<- 3
layer0to5[layer0to5==7]<- 5
layer0to5[layer0to5==8]<- 7
layer0to5[layer0to5==9]<- 6
layer0to5[layer0to5==10]<- 8
layer0to5[layer0to5==11]<- 9
layer0to5[layer0to5==12]<- 10
#########

#Replacing NA by -9 to ease conversion to asc later
layer0to5[is.na(layer0to5)]<- -9
Soildata <- stack(depth_bedrock,layer0to5)
Soildata <- as.data.frame(rasterToPoints(Soildata))

#Saving Original Soil data
save(Soildata,file="./Soildata_Original.Rdata")


# Step 2
# Adding row name in the data frame to keep track of it later on
Soildata$rowID <- row.names(Soildata)



#Step 3
# Creating a subset which contains only valid values
Soildata_valid <- subset(Soildata,!(Soildata$layer.1==-9 | Soildata$layer.2==-9))


#Step 4 
# Adding climate Index subsetted soil data and creating a unique simulation point ID
Soildata_valid$ClimateIndex <- NA
Soildata_valid$UniqueSimulation <- NA
N <- dim(Soildata_valid)[1]

save(Soildata_valid,file="./Soildata_valid.Rdata")







