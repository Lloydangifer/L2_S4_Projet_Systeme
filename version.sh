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
dirfile=$(dirname $2)/
vdir=$dirfile.version
if [ ! -d $vdir ]
then
    mkdir $vdir
fi
vfile=$vdir/$file
vfilelast=$vfile.latest
#########################################################
#manage the commands
#########################################################
case $1 in
    add)
	if [ -f $vfilelast ]
	then
	    echo '’'$file'’ already under versioning'
	    exit
	fi
	cp $2 $vfile.1
	cp $2 $vfilelast
	echo 'Added a new file under versioning: ’'$file'’'
	;;
    checkout) echo 'Not implemented';;
    commit) echo 'Not implemented';;
    diff) echo 'Not implemented';;
    log) echo 'Not implemented';;
    revert) echo 'Not implemented';;
    rm)	
	if [ ! -f $vfilelast ] 
	then
	    echo '’'$file'’ is not under versioning'
	    exit
	fi
	echo 'Are you sure you want to delete ’'$file'’ from versioning ? (yes/no)'
	read choice
	if [ "$choice" = "yes" ]
	then
	    rm $vfile.*
	    testempty=$(ls $vdir|head -1)
	    if [ -z "$testempty" ]
	    then
		rm -d $vdir
	    fi
	    echo '’'$file'’ is not under versioning anymore.'
	elif [ "$choice" = "no" ]
	then
	    echo '’'$file'’not deleted from versioning'
	else
	    echo 'Not a valid choice'
	fi
	;;
    *) echo 'Error! This command name does not exist: ’'$1'’';;
esac
