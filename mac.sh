#!/bin/bash
IP='10.0.0.10'
MAC_TXT=`echo "$IP" | awk -F'.' '{print "0x02 0x42 "$1" "$2" "$3" "$4}'`
printf "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x" $MAC_TXT
