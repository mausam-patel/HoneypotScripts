#!/bin/bash
 
date=$(/bin/date +"%m-%d-%Y %T")
 
# Get health stats of the host
host_available_mem=$(/usr/bin/free | awk '/Mem:/ {print $7}')
host_available_disk=$(/bin/df | head -n8 | tail -n 7 | awk 'BEGIN {total=0} {total+=$4} END {print total}')
host_system_load=$(/usr/bin/uptime | cut -d 'v' -f 2 | cut -d ' ' -f 4)
 
# Get health stats of the UMD Network Interface in KB
host_inc_traffic=$(/sbin/ifconfig enp4s1 | awk '/RX packets/ {print $5}')
host_inc_traffic="$(($host_inc_traffic/1024))"
host_out_traffic=$(/sbin/ifconfig enp4s1 | awk '/TX packets/ {print $5}')
host_out_traffic="$(($host_out_traffic/1024))"
 
# Get health stats for container 101
c101_available_mem=$(/usr/sbin/pct exec 101 /usr/bin/free | awk '/Mem:/ {print $7}')
c101_available_disk=$(/usr/sbin/pct exec 101 /bin/df | tail -n 7 | awk 'BEGIN {total=0} {total+=$4} END {print total}')
c101_system_load=$(/usr/sbin/pct exec 101 /usr/bin/uptime | cut -d 'v' -f 2 | cut -d ' ' -f 4)
c101_inc_traffic=$(/usr/sbin/pct exec 101 /sbin/ifconfig eth0 | awk '/RX bytes/ {print $2}' | cut -d ':' -f 2)
c101_inc_traffic="$(($c101_inc_traffic/1024))"
c101_out_traffic=$(/usr/sbin/pct exec 101 /sbin/ifconfig eth0 | awk '/TX bytes/ {print $5}' | cut -d ':' -f 2)
c101_out_traffic="$(($c101_out_traffic/1024))"
 
# Get health stats for container 102
c102_available_mem=$(/usr/sbin/pct exec 102 /usr/bin/free | awk '/Mem:/ {print $7}')
c102_available_disk=$(/usr/sbin/pct exec 102 /bin/df | tail -n 7 | awk 'BEGIN {total=0} {total+=$4} END {print total}')
c102_system_load=$(/usr/sbin/pct exec 102 /usr/bin/uptime | cut -d 'v' -f 2 | cut -d ' ' -f 4)
c102_inc_traffic=$(/usr/sbin/pct exec 102 /sbin/ifconfig eth0 | awk '/RX bytes/ {print $2}' | cut -d ':' -f 2)
c102_inc_traffic="$(($c102_inc_traffic/1024))"
c102_out_traffic=$(/usr/sbin/pct exec 102 /sbin/ifconfig eth0 | awk '/TX bytes/ {print $5}' | cut -d ':' -f 2)
c102_out_traffic="$(($c102_out_traffic/1024))"
 
# Get health stats for container 103
c103_available_mem=$(/usr/sbin/pct exec 103 /usr/bin/free | awk '/Mem:/ {print $7}')
c103_available_disk=$(/usr/sbin/pct exec 103 /bin/df | tail -n 7 | awk 'BEGIN {total=0} {total+=$4} END {print total}')
c103_system_load=$(/usr/sbin/pct exec 103 /usr/bin/uptime | cut -d 'v' -f 2 | cut -d ' ' -f 4)
c103_inc_traffic=$(/usr/sbin/pct exec 103 /sbin/ifconfig eth0 | awk '/RX bytes/ {print $2}' | cut -d ':' -f 2)
c103_inc_traffic="$(($c103_inc_traffic/1024))"
c103_out_traffic=$(/usr/sbin/pct exec 103 /sbin/ifconfig eth0 | awk '/TX bytes/ {print $5}' | cut -d ':' -f 2)
c103_out_traffic="$(($c103_out_traffic/1024))"
 
# Get health stats for container 104
c104_available_mem=$(/usr/sbin/pct exec 104 /usr/bin/free | awk '/Mem:/ {print $7}')
c104_available_disk=$(/usr/sbin/pct exec 104 /bin/df | tail -n 7 | awk 'BEGIN {total=0} {total+=$4} END {print total}')
c104_system_load=$(/usr/sbin/pct exec 104 /usr/bin/uptime | cut -d 'v' -f 2 | cut -d ' ' -f 4)
c104_inc_traffic=$(/usr/sbin/pct exec 104 /sbin/ifconfig eth0 | awk '/RX bytes/ {print $2}' | cut -d ':' -f 2)
c104_inc_traffic="$(($c104_inc_traffic/1024))"
c104_out_traffic=$(/usr/sbin/pct exec 104 /sbin/ifconfig eth0 | awk '/TX bytes/ {print $5}' | cut -d ':' -f 2)
c104_out_traffic="$(($c104_out_traffic/1024))"
 
# Send data to google sheet
log -k /root/Honeypot_Project/Health_Logs/key -s https://docs.google.com/spreadsheets/d/1pXi_Qk1LvyuC077TRnM-sJzXs39-wawryjo_0ALNVWE/edit#gid=0 -d "$date,$host_available_mem,$host_available_disk,$host_system_load,$host_inc_traffic,$host_out_traffic,$c101_available_mem,$c101_available_disk,$c101_system_load,$c101_inc_traffic,$c101_out_traffic,$c102_available_mem,$c102_available_disk,$c102_system_load,$c102_inc_traffic,$c102_out_traffic,$c103_available_mem,$c103_available_disk,$c103_system_load,$c103_inc_traffic,$c103_out_traffic,$c104_available_mem,$c104_available_disk,$c104_system_load,$c104_inc_traffic,$c104_out_traffic"
