#!/bin/bash 

#Prompt the user for an IP address, then drop it using iptables

echo Please enter an Ip Address 
read ipaddress 
iptables -A INPUT -s $ipaddress -j DROP 
echo "The ip Address $ipaddress was sucessfuly blocked"
