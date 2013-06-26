#!/bin/bash

#cd `dirname $0`
cd `dirname $0`

#if [ -s ./cornerstone.sh ]
if [ -s cornerstone ]
then
	#./cornerstone.sh
	cornerstone
else
      echo -e "\n\033[1;4;31mcornerstone.sh could not be found!\033[0m\n"
fi
