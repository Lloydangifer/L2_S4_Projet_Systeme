#!/bin/sh

if [ $# -ne 2 ]
then
    echo 'Usage: version.sh <cmd> <file> [option]'
    echo 'where <cmd> can be: add checkout commit diff log revert rm'
    exit
elif [ ! -e $2 ] 
then
    echo 'Error!' $2 'is not a file.'
    exit
fi
case $1 in
        add) echo 'Added a new file under versioning: '$2'';;
	checkout) echo 'checkout test';;
	commit) echo 'commit test';;
	diff) echo 'diff test';;
	log) echo 'log test';;
	revert) echo 'revert test';;
	rm) echo 'rm test';;
	*) echo 'Error! This command name does not exist: ’'$1'’';;
esac
