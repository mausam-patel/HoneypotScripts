#!/bin/bash
 
count=0
 
for f in *.txt
do
        # Print ip address
        # echo "$f" | cut -d '.' -f 1,2,3,4
 
        # Compute session duration
        start_time=$(head -n 1 $f)
        end_time=$(tail -n 1 $f)
        elapsed_time=$((end_time - start_time))
        echo "$elapsed_time"
 
        count=$((count + 1))
done
 
echo "Total files processed: $count"
