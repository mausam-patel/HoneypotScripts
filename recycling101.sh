#!/bin/bash
 
ip=0
sessions=0
pid=0
filename="/root/Honeypot_Project/Attacker_Data/cont101/"
unix_time=0
time_diff=0
 
tail -F -n 1 /var/lib/lxc/101/rootfs/var/log/auth.log | while read a; do
        status=$(echo $a | awk '{print $6}')
        closed_status=$(echo $a | grep 'pam_unix(sshd:session): session closed' | awk '{print $8}')
        snoopy=$(echo $a | grep 'snoopy')
 
        time_diff=$(echo `date +%s`)
        time_diff=$((time_diff-unix_time))
 
        if [[ $unix_time -ne 0 && $time_diff -ge 3600 && $time_diff -le 99999 ]]
        then
                unix_time=0
                echo "KICKED" >> "$filename"
                /bin/date '+%s' >> "$filename"
 
                sed -i '$d' ~/Honeypot_Project/firewall/firewall_rules.sh
                echo "/sbin/iptables --table filter --insert FORWARD 1 --in-interface enp4s1 --out-interface vmbr0 --source $ip --destination 172.20.0.2 --protocol tcp --destination-port 22 --jump LOGGING2" >> ~/Honeypot_Project/firewall/firewall_rules.sh
                echo "exit 0" >> ~/Honeypot_Project/firewall/firewall_rules.sh
                /usr/sbin/pct exec 101 -- killall sshd
 
                iptables --table filter -D FORWARD --in-interface enp4s1 --out-interface vmbr0 --source $ip --destination 172.20.0.2 --protocol tcp --destination-port 22 --jump ACCEPT
                iptables --table filter -D FORWARD --in-interface enp4s1 --out-interface vmbr0 --source 0.0.0.0/0 --destination 172.20.0.2 --protocol tcp --destination-port 22 --jump DROP
                iptables --table filter --insert FORWARD 1 --in-interface enp4s1 --out-interface vmbr0 --source $ip --destination 172.20.0.2 --protocol tcp --destination-port 22 --jump LOGGING2
 
                pid=$(ps -aux | grep "[tail] -F -n 1 /var/lib/lxc/101" | awk '{print $2}' | head -n 1)
                exec ~/Honeypot_Project/restart101.sh $pid &
                exit 0
        fi
 
        if [[ "$status" = "Accepted" ]]
        then
                sessions=$((sessions+1))
                ip=$(echo $a | awk '{print $11}')
                echo `date` >> "/root/Honeypot_Project/debug.txt"
                echo $ip >> "/root/Honeypot_Project/debug.txt"
                echo $sessions >> "/root/Honeypot_Project/debug.txt"
                if [[ sessions -eq 1 ]]
                then
                        echo "Container 101 compromised by $ip" >> /root/Honeypot_Project/Alerts/compromises
                        unix_time=$(echo `date +%s`)
 
                        # create a new data file with the ip address as the name
                        filename="/root/Honeypot_Project/Attacker_Data/cont101/$ip"
                        /usr/bin/touch "$filename"
 
                        # push the current unix time (on the Proxmox machine) to the file
                        # this marks the start time
                        /bin/date '+%s' >> "$filename"
 
                        # configure the firewall to only accept traffic on this container from this ip
                        iptables --table filter --insert FORWARD 1 --in-interface enp4s1 --out-interface vmbr0 --source 0.0.0.0/0 --destination 172.20.0.2 --protocol tcp --destination-port 22 --jump DROP
                        iptables --table filter --insert FORWARD 1 --in-interface enp4s1 --out-interface vmbr0 --source $ip --destination 172.20.0.2 --protocol tcp --destination-port 22 --jump ACCEPT
                fi
        elif [[ ! -z "$snoopy" && $sessions -ge 1 ]]
        then
                # if the line from auth.log contains "snoopy" then we only send it if it's not automated
                echo $a >> "$filename"
 
        elif [[ "$closed_status" = "closed" && $sessions -ge 1 ]]
        then
                sessions=$((sessions-1))
                # ip=$(echo $a | awk '{print $8}')
                echo `date` >> "/root/Honeypot_Project/debug.txt"
                echo $ip >> "/root/Honeypot_Project/debug.txt"
                echo $sessions >> "/root/Honeypot_Project/debug.txt"
                if [[ sessions -eq 0 ]]
                then
                        # push the unix time to the data file
                        # this marks the end of the attacker's connection and the completion of the data file
                        /bin/date '+%s' >> "$filename"
 
                        sed -i '$d' ~/Honeypot_Project/firewall/firewall_rules.sh
                        echo "/sbin/iptables --table filter --insert FORWARD 1 --in-interface enp4s1 --out-interface vmbr0 --source $ip --destination 172.20.0.2 --protocol tcp --destination-port 22 --jump LOGGING2" >> ~/Honeypot_Project/firewall/firewall_rules.sh
                        echo "exit 0" >> ~/Honeypot_Project/firewall/firewall_rules.sh
                        iptables --table filter -D FORWARD --in-interface enp4s1 --out-interface vmbr0 --source $ip --destination 172.20.0.2 --protocol tcp --destination-port 22 --jump ACCEPT
                        iptables --table filter -D FORWARD --in-interface enp4s1 --out-interface vmbr0 --source 0.0.0.0/0 --destination 172.20.0.2 --protocol tcp --destination-port 22 --jump DROP
                        iptables --table filter --insert FORWARD 1 --in-interface enp4s1 --out-interface vmbr0 --source $ip --destination 172.20.0.2 --protocol tcp --destination-port 22 --jump LOGGING2
 
                        pid=$(ps -aux | grep "[tail] -F -n 1 /var/lib/lxc/101" | awk '{print $2}' | head -n 1)
                        exec ~/Honeypot_Project/restart101.sh $pid &
                        exit 0
                fi
        fi
done
exit 0
