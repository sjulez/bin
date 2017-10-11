#!/bin/bash

# we're parsing the output of "zpool status" here. in the hopes
# it never changes we can easily grep the right line and check
# for values via awk. If the output should change due to updates
# we will be warned (by a CRITICAL state of the check).

pool=home
exitcode=0
message=$(zpool status $pool | grep -P "^\s+scan" )

#first, we check if scrub repaired any errors
if [ $(echo $message | awk '{print $4}' ) -ne 0 ] ; then exitcode=2 ; fi

#second, we check if errors occured while checking
if [ $(echo $message | awk '{print $8}' ) -ne 0 ] ; then exitcode=2 ; fi

#third, we parse the date and check if its older than a month
stringdate=$(echo $message | awk '{ print $12 " " $13 " "  $15 }' )
zpooldate=$(date -d "$stringdate" +"%Y%m%d")
if [ $? -ge 1 ] ; then echo "CRITICAL - could not parse date - $message" ; exit 2 ; fi
today=$(date +%Y%m%d)
datediff=$(( $today - $zpooldate ))
if [ "$datediff" -ge 36 ] ; then exitcode=1 ; fi

case $exitcode in
	0 )
		echo "OK - $message"
		exit 0
		;;
	1 )
		echo "WARNING - $message"
		exit 1
		;;
	2 )
		echo "CRITICAL - $message"
		exit 2
		;;
	* )
		echo "UNKNOWN - $message"
		exit 3
		;;
esac
