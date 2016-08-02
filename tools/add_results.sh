#!/bin/bash

# The results directory is big, so use a script to git commit
cd results
for letter in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
do
	cd ${letter}
		git add *
		git commit -m "Update" *
  cd ..
done


