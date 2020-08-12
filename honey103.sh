pct exec 103 -- sudo service apache2 stop
pct exec 103 -- sudo apt-get purge apache2 apache2-utils apache2.2-bin apache2-common
pct exec 103 -- sudo apt-get autoremove
pct exec 103 -- sudo rm -rf /etc/apache2  
echo -e "Y" | pct exec 103 -- apt-get remove --purge php* libapache2* apache2*
 
pct exec 103 -- sudo apt update 
echo -e "Y" | pct exec 103 -- sudo apt-get install apache2 
 
 
cp /root/Honeypot_Project/iot/index.html  /var/lib/lxc/103/rootfs/var/www/html
