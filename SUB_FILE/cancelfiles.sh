#!/bin/bash
declare -a FIRSTNUMBER
declare -a SECONDNUMBER
PREFIX="ENERGY.txt"
FIRSTNUMBER=( 0 1 2 3 4)
SECONDNUMBER=( 0 1 2 3 4 5 6 7 8 9)
THIRD=0
tot1=${#FIRSTNUMBER[@]}							#numero di jobs (lunghezza array)
tot2=${#SECONDNUMBER[@]}

for (( i=0; i<${tot1} ; i+=1 )) ; do
	for((j=0; j<${tot2}; j+=1 )) ; do
	#file=${PREFIX}${FIRSTNUMBER[i]}${SECONDNUMBER[j]}${THIRD}
	file=${PREFIX}
	echo ${file}
	rm ${file}
	#echo "Deleted job " ${job}
	done
done
