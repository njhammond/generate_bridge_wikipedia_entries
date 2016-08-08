#!/bin/sh

FILE="5winners"
cat ${FILE}.txt | sed -e "s/^/\* [[/" -e "s/\$/]]/" > ${FILE}.wiki

FILE="10winners"
cat ${FILE}.txt | sed -e "s/^/\* [[/" -e "s/\$/]]/" > ${FILE}.wiki
