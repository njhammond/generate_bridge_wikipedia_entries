#!/bin/sh

# Script to grab data from Wikipedia.
# Used it to grab WBF IDs
mkdir -p players
cat names.txt | while read file
do
  cd players
  echo "Doing $file"
	no_spaces=`echo $file | sed -e "s/ /_/g"`
	out_file="${no_spaces}.edit"

#	http://en.wikipedia.org/w/index.php?title=Alvin_Roth&action=edit
	wget -O "${out_file}" "http://en.wikipedia.org/w/index.php?title=${no_spaces}&action=edit"  >"${no_spaces}.edit_out" 2>"$no_spaces.edit_err"

	ruby ../remove_headers.rb ${out_file}

	# Let's copy over the one from players
	cp "../../players/${file}" ${out_file}.1
	ruby ../remove_headers.rb ${out_file}.1

	diff ${out_file}.bridge ${out_file}.1.bridge > ${out_file}.diffs
	cat ${out_file}.diffs | \
		sed -e "/accessdate/d" | \
		sed -e "/author = /d" | \
		sed -e "/page = /d" | \
		sed -e "/^[0-9]/d" | \
		sed -e "/^---/d" | \
		sed -e "/cite news/d" | \
		sed -e "/ref names/d" | \
		sed -e "/ALTERNATIVE NAMES/d" | \
		sed -e "/DATE OF BIRTH/d" | \
		sed -e "/Persondata/d" | \
		sed -e "/Category:/d" > ${out_file}.check
  cd ..
done


