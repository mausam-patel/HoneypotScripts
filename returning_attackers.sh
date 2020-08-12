#!/bin/bash
 
# first clear the kernel ring buffer
dmesg --clear
 
# now follow the kernel ring buffer for new logged dropped packets
dmesg -H -w | while read a; do
 
        cont101=$(echo $a | grep 'CONTAINER 101')
        cont102=$(echo $a | grep 'CONTAINER 102')
        cont103=$(echo $a | grep 'CONTAINER 103')
        cont104=$(echo $a | grep 'CONTAINER 104')
 
        if [[ ! -z "$cont101" ]]
        then
                echo $a >> /root/Honeypot_Project/Attacker_Data/return_attacks/cont101
        elif [[ ! -z "$cont102" ]]
        then
                echo $a >> /root/Honeypot_Project/Attacker_Data/return_attacks/cont102
        elif [[ ! -z "$cont103" ]]
        then
                echo $a >> /root/Honeypot_Project/Attacker_Data/return_attacks/cont103
        elif [[ ! -z "$cont104" ]]
        then
                echo $a >> /root/Honeypot_Project/Attacker_Data/return_attacks/cont104
        fi
 
done
 
exit 0
