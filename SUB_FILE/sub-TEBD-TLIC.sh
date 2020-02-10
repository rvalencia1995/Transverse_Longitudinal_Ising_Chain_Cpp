#!/bin/bash
#non modificare---------------------------------------------------------
declare -a HX 
declare -a HZ
HX=(0 1 2 3) 		#hx= 0 , 0.1 , 0.2 , 0.4
HZ=(0 1 2 3 4 5)	#hz = 0.25 , 0.5 , 0.75 , 1. , 1.25 , 1.5
STATES=("UP" "DOWN" "DW")

#parametri a scelta-----------------------------------------------------			
STATE=0				#UP = 0 , DOWN = 1 , DOMAIN-WALL = 2
N=20				#lunghezza catena	
J=1					#coupling
TTOT=11				#tempo totale TEBD
TSTEP=0.01			#passo temporale
NMEAS=10			#ogni quanti passi temporali e' misurato l'osservabile
CHI=256				#massima bond dimension
LOCALVSCLUSTER=0 	#locale = 0 , cluster = 1

CURRENTDIR=/home/ricval/Scrivania/bin		#directory immediatamente precedente a quelle contenente 'SUB_FILES' 'EXEC_FILES' 'Programmi'

#modificare solamente i cicli: 'i' scorre i valori di hx, 'j' scorre i valori di hz

for i in 0
do
	for j in 0 1
	do
	workdir=../TLIC_N${N}_${STATES[${STATE}]}_HX${HX[i]}_HZ${HZ[j]}_CHI${CHI}
	echo $workdir
	if [ ! -d $workdir ]; then											# verifica che la directory da creare non esista già
		
		if ! mkdir $workdir ; then 										# verifica che la creazione della directory non sia fallita
        exit -1
		fi
		
		cd $workdir
			if [ ${LOCALVSCLUSTER} = 1 ]; then
				qsub -N TLIC_TEBD_N${N}_${STATES[${STATE}]}_HX${HX[i]}_HZ${HZ[j]}_CHI${CHI} -v STATE=${STATE},N=${N},J=${J},HX=${HX[i]},HZ=${HZ[j]},TTOT=${TTOT},TSTEP=${TSTEP},NMEAS=${NMEAS},CHI=${CHI},LOCALVSCLUSTER=${LOCALVSCLUSTER} ${CURRENTDIR}/EXEC_CLUSTER/exec-TEBD-TLIC.sh
			fi
			if [ ${LOCALVSCLUSTER} = 0 ]; then
				${CURRENTDIR}/EXEC_LOCALE/exec-TEBD-TLIC.sh ${STATE} ${N} ${J} ${HX[i]} ${HZ[j]} ${TTOT} ${TSTEP} ${NMEAS} ${CHI} ${LOCALVSCLUSTER} &
			fi
		cd ${CURRENTDIR}/SUB_FILE
		
	else
		cd $workdir
			if [ ${LOCALVSCLUSTER} = 1 ]; then
				qsub -N TLIC_TEBD_N${N}_${STATES[${STATE}]}_HX${HX[i]}_HZ${HZ[j]}_CHI${CHI} -v STATE=${STATE},N=${N},J=${J},HX=${HX[i]},HZ=${HZ[j]},TTOT=${TTOT},TSTEP=${TSTEP},NMEAS=${NMEAS},CHI=${CHI},LOCALVSCLUSTER=${LOCALVSCLUSTER} ${CURRENTDIR}/EXEC_CLUSTER/exec-INT-TEBD-TLIC.sh
			fi
			if [ ${LOCALVSCLUSTER} = 0 ]; then
				${CURRENTDIR}/EXEC_LOCALE/exec-INT-TEBD-TLIC.sh ${STATE} ${N} ${J} ${HX[i]} ${HZ[j]} ${TTOT} ${TSTEP} ${NMEAS} ${CHI} ${LOCALVSCLUSTER} &
			fi
		cd ${CURRENTDIR}/SUB_FILE
	fi
	done
done
