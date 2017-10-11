#!/bin/bash
server=$1
notAfter=$(echo | openssl s_client -showcerts -servername $server -connect $server:443 2>/dev/null | openssl x509 -inform pem -noout -dates | grep notAfter)
notAfter=$(echo $notAfter | sed 's/notAfter\=//')

certdate=$(date -d "${notAfter}" +"%Y%m%d")
today10=$(date -d "+10 days" +"%Y%m%d")
today=$(date +"%Y%m%d")

echo certdate $certdate
echo today10  $today10
echo today    $today

if [[ ${today10} -lt ${certdate} && ${today} -lt ${certdate} ]];
then
	echo "$1 cert date ok"
	exit 0
elif [[ ${today10} -ge ${certdate} && ${today} -lt ${certdate} ]];
then
	echo "$1 certificate will expire in less than 10 days"
	exit 1
else
	echo "certificate for $1  expired!!!!"
	exit 2
fi
