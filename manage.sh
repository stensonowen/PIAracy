#!/bin/bash

ALREADY_RUNNING=`ps -e | grep -c openvpn`

if [ "$ALREADY_RUNNING" -eq "0" ]
then
    echo No instances detected
else
    echo openvpn already running $ALREADY_RUNNING times
    echo please kill the other instances before running
    exit
fi

TRUE_IP=`curl https://icanhazip.com 2> /dev/null`
echo $TRUE_IP

echo $ALREADY_RUNNING


