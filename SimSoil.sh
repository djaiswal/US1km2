#!/bin/bash
#PBS -S /bin/bash
#PBS -q default
#PBS -M deepakebimodelling@gmail.com
#PBS -m abe
#PBS -t 1-114
#PBS -l walltime=24:00:00

module load R/3.2.0 #earlier it was 3.0.2
R CMD BATCH --no-save "--args $PBS_ARRAYID"  /home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/SoilScript_for_ClimateIndex.R  /home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/SoilScript_for_ClimateIndex$PBS_ARRAYID.Rout
