#!/bin/bash
#non modificare---------------------------------------------------------
declare -a HX 
declare -a HZ
HX=(0 1 2 3 4 5 6)
HZ=(0 1 2 3 4 5)
STATES=("UP" "DOWN" "DW")

#parametri a scelta-----------------------------------------------------
STATE=0				#UP = 0 , DOWN = 1 , DOMAIN-WALL = 2
N=20				#lunghezza catena	
TIMESTEP=0.01		#passo temporale
NMEAS=10			#ogni quanti passi temporali e' misurato l'osservabile
FULLCOUNTING=1		#Misuro FCS magnetizzazione longitudianale: no = 0 , si =1
FULLENTROPY=0		#Misuro entropia di entanglement in ogni bipartizione: no = 0 , si =1
HALFENTROPY=0		#Misuro entropia di entanglement in corrispondenza della meta': no = 0 , si =1
LOCALVSCLUSTER=0 	#locale = 0 , cluster = 1
CHI=400

CURRENTDIR=/home/ricval/Scrivania/bin		#directory immediatamente precedente a quelle contenente 'SUB_FILES' 'EXEC_FILES' 'Programmi'		

#se calcoli full counting statistics------------------------------------
NUMBERPOINTS=200	#numero di punti nello spazio complesso theta \in [-PI,+PI]
MAXLENGTH=10		#lunghezza massima sottosistema su cui misurare fcs

for i in 0 1 2 3
do
    for j in 0 1 2 3 4 5
	do
	workdir=../TLIC_N${N}_${STATES[${STATE}]}_HX${HX[i]}_HZ${HZ[j]}_CHI${CHI}
	echo $workdir
	if [ -d $workdir ]; then	
	cd $workdir
	echo "Directory " $workdir 
	
	if [ ${FULLCOUNTING} = 1 ]; then
		if [ ${LOCALVSCLUSTER} = 1 ]; then
			qsub -N N${N}_FCS_${STATES[${STATE}]}_HX${HX[i]}_HZ${HZ[j]} -v N=${N},TIMESTEP=${TIMESTEP},NMEAS=${NMEAS},HX=${HX[i]},HZ=${HZ[j]},NUMBERPOINTS=${NUMBERPOINTS},MAXLENGTH=${MAXLENGTH},LOCALVSCLUSTER=${LOCALVSCLUSTER} ${CURRENTDIR}/EXEC_CLUSTER/exec-full-counting-statistics.sh
		fi
		if [ ${LOCALVSCLUSTER} = 0 ]; then
			${CURRENTDIR}/EXEC_LOCALE/exec-full-counting-statistics.sh ${N} ${TIMESTEP} ${NMEAS} ${HX[i]} ${HZ[j]} ${NUMBERPOINTS} ${MAXLENGTH} ${LOCALVSCLUSTER} &
		fi
	fi
	
	if [ ${FULLENTROPY} = 1 ]; then
		if [ ${LOCALVSCLUSTER} = 1 ]; then
			qsub -N N${N}_FEE_${STATES[${STATE}]}_HX${HX[i]}_HZ${HZ[j]} -v N=${N},TSTEP=${TSTEP},NMEAS=${NMEAS},LOCALVSCLUSTER=${LOCALVSCLUSTER}  ${CURRENTDIR}/EXEC_CLUSTER/exec-entropy-full.sh
		fi
		if [ ${LOCALVSCLUSTER} = 0 ]; then
			${CURRENTDIR}/EXEC_LOCALE/exec-entropy-full.sh ${N} ${TSTEP} ${NMEAS} ${LOCALVSCLUSTER} &
		fi
	fi
	
	if [ ${HALFENTROPY} = 1 ]; then
		if [ $LOCALVSCLUSTER=1 ]; then
			qsub -N N${N}_HEE_${STATES[${STATE}]}_HX${HX[i]}_HZ${HZ[j]} -v N=${N},TSTEP=${TSTEP},NMEAS=${NMEAS},LOCALVSCLUSTER=${LOCALVSCLUSTER}  ${CURRENTDIR}/EXEC_CLUSTER/exec-entropy-half.sh
		fi
		if [ ${LOCALVSCLUSTER} = 0 ]; then
			${CURRENTDIR}/EXEC_LOCALE/exec-entropy-half.sh ${N} ${TSTEP} ${NMEAS} ${LOCALVSCLUSTER} &
		fi
	fi
	cd ..
     #   cd ..
    fi
	done
done
