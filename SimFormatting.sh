#!/bin/bash
#PBS -S /bin/bash
#PBS -q default
#PBS -M deepakebimodelling@gmail.com
#PBS -m abe
#PBS -t 1-114
#PBS -l walltime=1:00:00
#PBS -l mem=4GB

module load R/3.2.0 #earlier it was 3.0.2
R CMD BATCH --no-save "--args $PBS_ARRAYID"  /home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/FormatedOutput.R  /home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/FormatedOutput$PBS_ARRAYID.Rout
