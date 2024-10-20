#!/bin/bash

# Shawn Yat Sin
# School of Computer Science
# shawn.yatsin@mail.mcgill.ca

if [[ $# -ne 2 ]]
then
	echo Error: Expected two input parameters.
	echo 'Usage: ./deltad.bash <originaldirectory> <comparisondirectory>'
	exit 1

elif [[ ! -d $1 ]] || [[ ! -d $2 ]] || [[ $1 -ef $2 ]]
then
	if [[ ! -d $1 ]]
	then
		echo "Error: Input parameter #1 '$1' is not a directory."
	
	elif [[ ! -d $2 ]]
	then
		echo "Error: Input parameter #2 '$2' is not a directory."
	else
		echo "Error: Input parameters #1 '$1' and #2 '$2' are the same directories."
	fi

	echo 'Usage: ./deltad.bash <originaldirectory> <comparisondirectory>'
	exit 2
fi

listfiles1=$(ls $1)
listfiles2=$(ls $2)

for file in $listfiles1   # iterate through files in first directory
do
	if [[ -f $1/$file ]]    # if the file is a regular file
	then
		missingcheck=0     # variable to check if file is in both directories
		for file2 in $listfiles2
		do	
			if [[ -f $2/$file2 ]] # if file2 is a regular file
			then
				if [[ $file = $file2 ]]   # if file in both directories
				then
					missingcheck=1  # update variable to show not file in first directory not missing
					if diff -q $1/$file $2/$file2 | grep -q 'differ'  # if grep exits with value 0 meaning there was the word differ
					then
						echo "$1/$file differs"
					fi
					
				fi
			fi
		done

		if [[ $missingcheck = 0 ]]
		then
			echo "$1/$file is missing"
		fi
	fi
done

for file2 in $listfiles2
do
	if [[ -f $2/$file2 ]]
	then
		missingcheck2=0
		for file in $listfiles1
		do
			if [[ -f $1/$file ]]
			then
				if [[ $file2 = $file ]]
				then 
					missingcheck2=1
				fi
			fi
		done
		
		if [[ $missingcheck2 = 0 ]]
		then
			echo "$2/$file2 is missing "
		fi
	fi
done







