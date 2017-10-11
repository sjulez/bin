#!/bin/bash

#capacity=$(zpool pool get all home | grep capacity | awk '{print substr($3,0,2)}')
#fragmentation=$(zpool pool get all home | grep fragmentation | awk '{print substr($3,0,2)}')
capacity=$(grep capacity zpool_get_all_home.out | awk '{print substr($3,0,2)}')
fragmentation=$(grep fragmentation zpool_get_all_home.out | awk '{print substr($3,0,2)}')

exitcode=0

#check capacity
if [ $capacity -ge 70 && $capacity -lt 90 ]
then
	exitcode=1
elif [ $capacity -ge 90 ]
then
	exitcode= 2
fi

#check fragmentation
if [ $fragmentation -ge 70 && $fragmentation -lt 90 ]
then
	exitcode=1
elif [ $fragmentation -ge 90 ]
then
	exitcode=2
fi

case $exitcode in
	0)
		echo "OK - ZFS on $(hostname) is fine. Capacity = $capacity % // Fragmentation = $fragmentation %"
		exit 0
		;;
	1)
		echo "WARNING! - ZFS on $(hostname) is in Warning-State! Capacity = $capacity % // Fragmentation = $fragmentation %"
		exit 1
		;;
	2)
		echo "CRITICAL -  ZFS on $(hostname) is in Critical-State! Capacity = $capacity % // Fragmentation = $fragmentation %"
		exit 2
		;;
	*)
		echo "UNKNOWN - Something went wrong with cheching ZFS on $hostname - can't determine exitcode"
		exit 3
		;;
esac
