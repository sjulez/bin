#!/usr/bin/perl
#
#script gets last entry of measurement 'cpu_value' in influxdb
#and checks if the measurement ist older than 30 seconds.
#(default time for incoming data 10sec)
#
# Exit-Codes:
# 0 = $STATE_OK
# 1 = $STATE_WARNING <-- not used
# 2 = $STATE_CRITICAL
#

@lastvalue = `influx -database collectd -execute 'select last(value) from cpu_value'`;
$currenttimestamp = `date +%s`;

if ($lastvalue[3] =~ /^(\d{10})/){
	$timediff = $currenttimestamp - $1;
}

if ($timediff <= 60){
	print $timediff."\n";
	print "OK - Influxdb works fine. Last entry is $timediff seconds old.\n";
	exit 0
}
else {
	print $timediff."\n";
	print "CRITICAL - The last entry is $timediff seconds old!\n";
	exit 2
}
