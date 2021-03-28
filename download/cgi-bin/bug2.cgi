#!/bin/bash

cat /www/logs/gnosis-access-log all_visitors | awk '{print $1}' | sort | uniq > new_all
mv new_all all_visitors

echo "Content-type: text/plain"
echo
echo "Total: " `wc all_visitors | cut -b -7` "(since Apr 24, 2005)"
echo "===================================="
#cat all_visitors

