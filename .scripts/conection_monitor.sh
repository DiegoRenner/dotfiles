#!/bin/bash

while true 
do
	date | tee log_test.txt
	netstat -a | grep tcp | tee -a log_test.txt 
	#netstat -a | grep udp | tee -a log_test.txt 
	sleep 1
done
