#!/bin/bash

#modificare-------------------------------------------------------------
CURRENTDIR=/home/ricval/Scrivania/bin									#directory corrente dove sta eseguibile
bin_file_name=${CURRENTDIR}/Programmi/ENTROPY_ALL

#non modificare--------------------------------------------------------
N=$1
TSTEP=$2
NMEAS=$3
LOCALVSCLUSTER=$4

$bin_file_name $N $TSTEP $NMEAS $LOCALVSCLUSTER >> out_entropy_full.dat &
