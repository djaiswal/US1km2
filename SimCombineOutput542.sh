#!/bin/bash
#PBS -S /bin/bash
#PBS -q highthroughput
#PBS -M deepakebimodelling@gmail.com
#PBS -m abe
#PBS -l walltime=3:00:00
#PBS -l mem=2GB

module load R/3.2.0 #earlier it was 3.0.2
R CMD BATCH --no-save "--args 542"  /home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/CombinedFormatedOutput.R  /home/a-m/djaiswal/Scripts/BioCroSimulations/USA/Marshalheap/SoilLayers/US1km2/CombinedFormatedOutput542.Rout
