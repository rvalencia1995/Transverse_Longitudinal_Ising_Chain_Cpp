#!/bin/bash

#modificare-------------------------------------------------------------
CURRENTDIR=/home/ricval/Scrivania/bin									#directory corrente dove sta eseguibile
bin_file_name=${CURRENTDIR}/Programmi/INT_TEBD_TLIC

#non modificare---------------------------------------------------------
STATE=$1
N=$2
J=$3
HX=$4
HZ=$5
TTOTAL=$6
TIMESTEP=$7
NMEAS=$8
CHI=$9
LOCALVSCLUSTER=$10

$bin_file_name $STATE $N $J $HX $HZ $TTOTAL $TIMESTEP $NMEAS $CHI $LOCALVSCLUSTER > TEBD.txt 
