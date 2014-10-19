#!/bin/sh

# Script to grab data from Wikipedia.
# Used it to grab WBF IDs
mkdir -p players
cat names.txt | while read file
do
  echo "Doing $file"
	wget -O "players/$file" "http://en.wikipedia.org/wiki/$file"  >"players/${file}.out" 2>"players/$file.err"
done


