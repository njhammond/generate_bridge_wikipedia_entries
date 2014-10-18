#!/bin/sh

# Quick shell script to find missing WBF IDs
cat 10winners.txt | while read player
do
  grep "${player}" wbf_ids.csv >/dev/null
	[ $? -ne 0 ] && echo "Do not have a WBF ID for: ${player}"
done

