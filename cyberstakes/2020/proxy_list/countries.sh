#!/bin/bash

for ip in $(cat ips.txt); do
   echo "$(geoiplookup $ip)" >> countries.txt
done

cat countries.txt | sort | uniq -c | sort -rn | head -n1
