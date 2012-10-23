#!/bin/bash

# Gets IP address
function getIP {
	local IP=''
	/sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}' $IP
	echo "$IP"
}

IP=$(getIP)
eval $(echo "$IP" | awk '{print "IP1="$1";IP2="$2";IP3="$3";IP4="$4}' FS=.)

firstSegment=$IP1

if [ $firstSegment == '10' ]
then

	umount /home/warren/gaikai
	mount -t vboxsf "gaikai-work" /home/warren/gaikai

elif [ $firstSegment == '192' ]
then

	umount /home/warren/gaikai
	mount -t vboxsf gaikai /home/warren/gaikai

fi