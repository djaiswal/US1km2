rm(list=ls())
args <- commandArgs(TRUE)

if(length(args) == 0){
  warning("args is missing")
}else{
  start <- as.numeric(args)
}
#Loading BioCro
library(BioCro,lib.loc="/home/a-m/djaiswal/R/library")
library(raster)



#Function to get NARR data
source("/home/a-m/djaiswal/Scripts/ClimateProcessing/NARR/getNARRforBioCro.R")




depth_bedrock <- raster("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Depth_To_Bedrock_Water.asc")

layer0to5 <- raster("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/soil1.asc")
'
png("soil2.png")
layer5to10 <- raster("./soil2.asc")
spplot(layer5to10)
dev.off()

png("soil3.png")
layer10to20 <- raster("./soil3.asc")
spplot(layer10to20)
dev.off()

png("soil4.png")
layer20to30 <- raster("./soil4.asc")
spplot(layer20to30)
dev.off()

png("soil5.png")
layer30to40 <- raster("./soil5.asc")
spplot(layer30to40)
dev.off()

png("soil6.png")
layer40to60 <- raster("./soil6.asc")
spplot(layer40to60)
dev.off()

png("soil7.png")
layer60to80 <- raster("./soil7.asc")
spplot(layer60to80)
dev.off()

png("soil8.png")
layer80to100 <- raster("./soil8.asc")
spplot(layer80to100)
dev.off()
'

#Changing from cm to m
depth_bedrock <- depth_bedrock /100
# There is not much difference between 0-5, 5-10, and 10-20 cm soil texture' therefore I am simply going to use data from layer0to5 as soil texture.
depth_bedrock[is.na(depth_bedrock)]<- -9



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

Soildata$rowID <- row.names(Soildata)
Soildata_subset <- subset(Soildata,!(Soildata$layer.1==-9 | Soildata$layer.2==-9))

iRhizome <- 6
Co2level=380
day1=15 #15 January
dayn=349 # 15 December
startyear=1979
endyear=2010
harvestduration=7

N<- dim(Soildata_subset)[1]
istart<-(start)*10000+1
iend <-(start+1)*10000
iend <- ifelse(iend>N,N,iend)
finaloutput <- NULL
ii=1 #Fake index to store gridoutput
jj=1#Fake index to store gridoutput
Tmin=1#Fake to avoid error when soil = -9
for ( i in istart:iend){
    currentyear <- startyear
    output <- NULL
    repeat{
        currentyear<-currentyear+1
        if(currentyear>endyear){
            break}
      dat<- NULL
      lat <-Soildata_subset$y[i]
      lon <- Soildata_subset$x[i]
      soilDepth <- Soildata_subset$layer.1[i]
      SoilType <-  Soildata_subset$layer.2[i]
     if((Soildata_subset$layer.1[i]!=-9)&&(Soildata_subset$layer.2[i]!=-9)){
         dat <- getNARRforBioCro(lat,lon,currentyear)
          soilP <- soilParms(wsFun="logistic",phi1=0.0177,phi2=0.83,rfl=0.4,soilLayers=1,soilDepth=soilDepth,soilType=SoilType)
      res1<- caneGro(dat,lat=lat, soilControl=soilP,photoControl=list(Catm=Co2level),day1 = day1, dayn = dayn,iRhizome=iRhizome,irtl=1e-2)
          stem1<-res1$Stem[length(res1$Stem)]
          leaf1<-res1$Leaf[length(res1$Leaf)]
          root1 <-res1$Root[length(res1$Root)]
          Seedcane1 <- res1$Seedcane[length(res1$Seedcane)]
          leaflitter1<- res1$LeafLittervec[length(res1$LeafLittervec)]
     }else{
         stem1 <- -9
         leaf1<- -9
         Seedcane1 <- -9
         rhiz1 <- -9
         leaflitter1 <- -9
     }
     tmpoutput<-as.vector(c(currentyear,stem1, leaf1,root1,Seedcane1,leaflitter1))
     output<-as.vector(c(output,tmpoutput))
      output<-as.vector(c(output,stem1*0.89)) # we still need to save output because sugarcane is harvested every year
    } #end repeat
    gridoutput<-as.vector(c(c(ii,jj,lat,lon,Tmin),output))
    finaloutput <- rbind(finaloutput,gridoutput)
} # end main for loop

save(finaloutput,file=paste("/home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/Results/",formatC(istart,width=8,flag=0,format="d"),formatC(iend,width=8,flag=0,format="d"),".RData",sep=""))



'
source("/home/a-m/djaiswal/Scripts/ClimateProcessing/NARR/getNARRforBioCro.R")
N<- dim(Soildata)[1]
Soildata$NarrIndex<- NA
Soildata$NarrI<- NA
Soildata$NarrJ<- NA
USlayer<-read.table("/home/groups/ebimodeling/met/NARR/ProcessedNARR/NARRindex.txt")
for ( i in 1:N){
    if(Soildata$layer.1[i]!=-9){
        lat<-Soildata$y[i]
        lon <- Soildata$x[i]
        index=which.min((lat-USlayer$Latt)^2+(lon-USlayer$Lonn)^2)
        Soildata$NarrIndex[i]=index
        Soildata$NarrI[i]=USlayer$Iindex[index]
        Soildata$NarrJ[i]=USlayer$Jindex[index]
    }else{
         Soildata$NarrIndex[i]= -9
         Soildata$NarrI[i]=-9
         Soildata$NarrJ[i]=-9
     }
}
'

        

        
        
        
        







