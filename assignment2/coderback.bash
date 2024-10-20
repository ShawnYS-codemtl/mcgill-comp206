#!/bin/bash

# Shawn Yat Sin
# School of Computer Science
# shawn.yatsin@mail.mcgill.ca

date=$(date '+%Y%m%d')
tarfile=$1/$(basename $2).$date.tar

if [[ $# -ne 2 ]]     # if nb of args is not equal to 2
then
      echo 'Error: Expected two input parameters.'
      echo 'Usage: ./coderback.bash <backupdirectory> <fileordirtobackup>'      
      exit 1

elif [[ ! -d $1 ]]   # if the first argument is not an existing dir
then
	echo "Error: The directory '$1' does not exist."
	exit 2

elif [[ ! -e $2 ]]  # if the second argument is not an existing file/dir
then 
	echo "Error: The directory/file '$2' to backup does not exist."
	exit 2

elif [[ $1 -ef $2 ]] # if directories are the same
then
	echo "Error: Both source and destination are the same directory."
	exit 2

elif [[ -f $tarfile ]]  # if tar file with same name already exists
then
        echo "Backup file '$(basename $2).$date.tar' already exists. Overwrite? (y/n)"
	read answer
	case $answer in
		"y")
		archive=$(tar -cvPf $tarfile $2)
                exit 0;;

		*) exit 3;;
	esac
fi


archive=$(tar -cvPf $tarfile $2)
