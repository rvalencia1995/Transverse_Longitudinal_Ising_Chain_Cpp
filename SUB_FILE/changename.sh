#!/bin/bash
declare -a HX
declare -a HZ
HX=(0 1 2 3)
HZ=(0 1 2 3 4 5)
STATE=UP
CHI=500
N=80
for i in 0 1 2 3
	do
	for j in 0 1 2 3 4 5
	do
		workdir=N${N}_${STATE}_HX${HX[i]}_HZ${HZ[j]}_CHI${CHI}
		mv ${STATE}_HX${HX[i]}_HZ${HZ[j]} $workdir
	done
done
