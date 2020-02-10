#!/bin/bash
declare -a FIRSTNUMBER
declare -a SECONDNUMBER
PREFIX="28039"
SUFFIX=".master1"
FIRSTNUMBER=(0 1 2 3 4 5 6 7 8 9)
SECONDNUMBER=(0 1 2 3 4 5 6 7 8 9)
tot1=${#FIRSTNUMBER[@]}							#numero di jobs (lunghezza array)
tot2=${#SECONDNUMBER[@]}

for (( i=0 ; i<${tot1} ; i+=1 )) ; do
	for((j=0; j<${tot2}; j+=1 )) ; do
	job=${PREFIX}${FIRSTNUMBER[i]}${SECONDNUMBER[j]}${SUFFIX}
	echo ${job}
	qdel ${job}
	#echo "Deleted job " ${job}
	done
done
