#!/bin/sh
#
# Move files from "players" to "results"

mkdir -p results
cd results
for dir in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
do
    mkdir -p $dir
done
cd ..
cd players

echo "Ignore any errors about no player starting with Q, X, Y"
for dir in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
do
#  if [ -e ${dir}* ]; then
    mv ${dir}* ../results/${dir}
#	fi
done


