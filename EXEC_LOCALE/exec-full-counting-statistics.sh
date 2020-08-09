#!/bin/bash

#modificare-------------------------------------------------------------
CURRENTDIR=${PWD}									#directory corrente dove sta eseguibile
bin_file_name=${CURRENTDIR}/Programmi/FULL_COUNTING_STATISTICS

echo ${bin_file_name}
#non modificare---------------------------------------------------------
N=$1
TIMESTEP=$2
NMEAS=$3
HX=$4
HZ=$5
NUMBERPOINTS=$6
MAXLENGTH=$7
LOCALVSCLUSTER=$8
	
$bin_file_name $N $HX $HZ $TIMESTEP $NMEAS ${NUMBERPOINTS} $MAXLENGTH $LOCALVSCLUSTER >> out_fcs.txt &
