#!/bin/bash

echo "sono in sub-INT-MEAS.sh"

#modificare-------------------------------------------------------------
FULLCOUNTING=1		#Misuro FCS magnetizzazione longitudianale: no = 0 , si =1
FULLENTROPY=1		#Misuro entropia di entanglement in ogni bipartizione: no = 0 , si =1
HALFENTROPY=1		#Misuro entropia di entanglement in corrispondenza della meta': no = 0 , si =1

CURRENTDIR=/home/ricval/Scrivania/bin	#directory immediatamente precedente a quelle contenente 'SUB_FILES' 'EXEC_FILES' 'Programmi'

#non modificare---------------------------------------------------------
#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
STATES=("UP" "DOWN" "DW")
STATE=$1			#UP = 0 , DOWN = 1 , DOMAIN-WALL = 2
N=$2				#lunghezza catena	
TSTEP=$3			#passo temporale
NMEAS=$4			#ogni quanti passi temporali e' misurato l'osservabile
HX=$5				#hx	(longitudinale)
HZ=$6				#hz (trasversale)
LOCALVSCLUSTER=$7 	#locale = 0 , cluster = 1
#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
#-----------------------------------------------------------------------


#se si vuole misurare la full counting statistics-----------------------
NUMBERPOINTS=200		#numero di punti in cui campionare la full counting statistics
MAXLENGTH=$(( ${N}/2 ))	#massima dimensione del sottosistema considerato


#non modificare---------------------------------------------------------
#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
if [ ${LOCALVSCLUSTER} = 0 ]; then

	if [ ${FULLCOUNTING} = 1 ]; then
		${CURRENTDIR}/EXEC_LOCALE/exec-full-counting-statistics.sh ${N} ${TSTEP} ${NMEAS} ${HX[i]} ${HZ[j]} ${NUMBERPOINTS} ${MAXLENGTH} ${LOCALVSCLUSTER} &
	fi
	
	if [ ${FULLENTROPY} = 1 ]; then
		${CURRENTDIR}/EXEC_LOCALE/exec-entropy-full.sh ${N} ${TSTEP} ${NMEAS} ${LOCALVSCLUSTER} &
	fi
	
	if [ ${HALFENTROPY} = 1 ]; then
		${CURRENTDIR}/EXEC_LOCALE/exec-entropy-half.sh ${N} ${TSTEP} ${NMEAS} ${LOCALVSCLUSTER} &	
	fi

fi

if [ ${LOCALVSCLUSTER} = 1 ]; then

	if [ ${FULLCOUNTING} = 1 ]; then
		qsub -N N${N}_FCS_${STATES[${STATE}]}_HX${HX[i]}_HZ${HZ[j]} -v N=${N},TSTEP=${TSTEP},NMEAS=${NMEAS},HX=${HX[i]},HZ=${HZ[j]},NUMBERPOINTS=${NUMBERPOINTS},MAXLENGTH=${MAXLENGTH},LOCALVSCLUSTER=${LOCALVSCLUSTER} ${CURRENTDIR}/EXEC_CLUSTER/exec-full-counting-statistics.sh
	fi
	
	if [ ${FULLENTROPY} = 1 ]; then
		qsub -N N${N}_FEE_${STATES[${STATE}]}_HX${HX[i]}_HZ${HZ[j]} -v N=${N},TSTEP=${TSTEP},NMEAS=${NMEAS},LOCALVSCLUSTER=${LOCALVSCLUSTER}  ${CURRENTDIR}/EXEC_CLUSTER/exec-entropy-full.sh	
	fi
	
	if [ ${HALFENTROPY} = 1 ]; then
		qsub -N N${N}_HEE_${STATES[${STATE}]}_HX${HX[i]}_HZ${HZ[j]} -v N=${N},TSTEP=${TSTEP},NMEAS=${NMEAS},LOCALVSCLUSTER=${LOCALVSCLUSTER}  ${CURRENTDIR}/EXEC_CLUSTER/exec-entropy-half.sh	
	fi

fi





















