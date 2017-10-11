#!/bin/bash

#### function definitions #########################################################
# functions get called when we know there are (too many) files in the directory
function evalCount(){
	case $1 in
		[1-2])
			exitcode=1
			;;
		[3-9])
			exitcode=2
			;;
	esac
}

function evalExitcode(){
	if [ "$1" -gt 2 ]
	then
		echo "CRITICAL - too many files in-$inout queue!"
		exit 2
	elif [ "$1" -le 2 ]
	then
		echo "WARNING! - too many files in-$inout queue!"
		exit 1
	fi
}
###################################################################################

exitcode=0

#check if flush-file is present, it has to be. Therefore crit if it isn't present.
if [ ! -f /var/spool/dma/flush ]
then
	echo "CRITICAL - no flush-file in directory /var/spool/dma/"
	exit 2
fi

#check if there are too many out- or too many in-files
count_in=$(find /var/spool/dma/ -iname Q* -type f | wc -l)
count_out=$(find /var/spool/dma/ -iname M* -type f | wc -l)

#everything is fine, nothing to do
if [[ "$count_out" -eq 0 && "$count_in" -eq 0 ]]
then
	echo "OK - DMA Mail0r works fine"
	exit 0
fi

#there is something wrong in in- or out-queue at this point
inout="out"
echo "calling EvakCount with count_out=$count_out" ; evalCount $count_out
evalExitcode $exitcode

inout="in"
evalCount $count_in
evalExitcode $exitcode
