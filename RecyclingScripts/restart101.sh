#!/bin/bash
kill $1
sleep 5
pct stop 101
pct unmount 101
pct rollback 101 snap1
pct mount 101
pct start 101
exec ~/Honeypot_Project/recycling101.sh
 
exit 0
