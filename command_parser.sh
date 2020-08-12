#!/bin/bash
 
countCommandsperSess=0
 
for f in *
do
        countCommandsperSess=`cat $f | grep 'SSH_CONNECTION' | cut -d ':' -f '8' | wc -l`
        echo "$countCommandsperSess"
done
 
exit 0
