#!/bin/sh

if [ $# -ne 2 ]
then
    echo 'Usage: version.sh <cmd> <file> [option]'
    echo 'where <cmd> can be: add checkout commit diff log revert rm'
elif [ -e $2 ] 
then
    echo 'Error! ’$2.txt’ is not a file.'
fi
