#!/bin/sh

########################################################
#check if the parameters for the script are corrects
########################################################
if [ $# -ne 2 ]
then
    echo 'Usage: version.sh <cmd> <file> [option]'
    echo 'where <cmd> can be: add checkout commit diff log revert rm'
    exit
elif [ ! -f $2 ] 
then
    echo 'Error!' $2 'is not a file.'
    exit
fi
########################################################
#check if the file is in the same directory as .version, else, create .version
########################################################
file=$(basename $2)
#echo 'file: '$file #for debug
dirfile=$(dirname $2)/
#echo 'directory: '$dirfile #for debug
vdir=$dirfile.version
#echo 'dirfile: '$vdir
if [ ! -d $vdir ]
then
    mkdir $vdir
    #echo '.version directory created' #for debug
    #else #for debug
    #echo '.version already exists in the same directory of '$file #for debug
fi
vfile=$vdir/$file
#echo 'managed file: '$vfile #for debug
vfilelast=$vfile.latest
#echo 'vfilelast: '$vfilelast #for debug
#########################################################
#manage the commands
#########################################################
case $1 in
    add)
	if [ -f $vfilelast ]
	then
	    echo '’'$2'’ already under versioning'
	    exit
	fi
	cp $2 $vfile.1
	cp $2 $vfilelast
	echo 'Added a new file under versioning: ’'$2'’'
	;;
    checkout) 
	echo 'Not implemented'
	;;
    commit) echo 'Not implemented';;
    diff) echo 'Not implemented';;
    log) echo 'Not implemented';;
    revert) echo 'Not implemented';;
    rm)	
	echo 'Are you sure you want to delete ’'$2'’ from versioning ? (yes/no)'
	read $choice
	if [ "$choice" = "yes" ]
	then
	    rm $vfile.*
	    if [ ! -s $vdir ]
	    then
		rm -d $vdir
	    fi
	elif [ "$choice" = "no" ]
	then
	    echo $2 'not deleted from versioning'
	else
	    echo 'Not a valid choice'
	fi ;;
    *) echo 'Error! This command name does not exist: ’'$1'’';;
esac
