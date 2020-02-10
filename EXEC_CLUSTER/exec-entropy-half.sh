#!/bin/bash
#PBS -l walltime=12:00:00
#PBS -l nodes=1:ppn=20
#PBS -q regular
#PBS -j eo
#PBS -e PBS_eo_MEAS.txt
cd $PBS_O_WORKDIR

#modifica---------------------------------------------------------------
CURRENTDIR=/home/ricval/Scrivania/bin 									#directory dove sta l'eseguibile 
bin_file_name=${CURRENTDIR}/Programmi/ENTROPY_HALF						#eseguibile

#non modificare---------------------------------------------------------
module load mkl/11.1
module load gcc/4.8.2
$bin_file_name $N $TIMESTEP $NMEAS $LOCALVSCLUSTER >> out_entropy_half.dat
