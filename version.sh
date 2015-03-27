#!/bin/sh

#Virgil Manrique

########################################################
# check if the parameters for the script are corrects
########################################################
if [ $# -ne 3 -a "$1" = "checkout" ]
then
    echo 'Usage of command checkout:'
    echo 'version.sh checkout <file> number'
    echo 'where number is the number of the wished version'
    exit 1
elif [ $# -ne 3 -a "$1" = "commit" ]
then
    echo 'Usage of command commit:'
    echo 'version.sh commit <file> "comment"'
    echo 'where "comment" is a commentary for the log'
    exit 1
elif [ $# -ne 2 -a "$1" != "commit" -a "$1" != "checkout" ]
then
    echo 'Usage: version.sh <cmd> <file> [option]'
    echo 'where <cmd> can be: add checkout commit diff log revert rm'
    exit 1
fi
if [ ! -f $2 ] 
then
    echo 'Error!' $2 'is not a file.'
    exit 1
fi
########################################################
# check if the file is in the same directory as .version, else, create .version
########################################################
file=$(basename $2)
dirfile=$(dirname $2)/
vdir=$dirfile.version
if [ ! -d $vdir ]
then
    mkdir $vdir
fi
vfile=$vdir/$file
#######################################################
# functions who are used in the "case" command below
#######################################################
check_managed_file(){
    if [ ! -f $1.latest ]
    then
	echo '’'$2'’ not under versioning. Try the "add" command.'
	exit 1
    fi
    return 0
}
case_add(){
    if [ -f $1.latest ]
    then
	echo '’'$3'’ already under versioning.'
	exit 1
    fi
    cp $2 $1.1
    cp $2 $1.latest
    echo 'Added a new file under versioning: ’'$3'’'
    return 0
}
case_checkout(){
    check_managed_file $1 $4
    cp $1.1 $2
    if [ "$3" != "1" ]
    then
	vwished=$(seq 2 $3) #wished version
	for version in $vwished
	do
	    patch -u -s $2 $1.$version
	done
    fi
    echo 'Checked out version:'$3
    return 0
}
case_commit(){
    check_managed_file $1 $3
    cmp $2 $1.latest 1>/dev/null 2>&1
    filecmp=$?
    if [ $filecmp -eq 0 ]
    then
	echo '’'$3'’ is already the latest version, commit aborted.'
	exit 1
    else
	filenum=2
	continuer=1
	while [ $continuer -eq 1 ]
	do
	    if [ -f $1.$filenum ]
	    then
		filenum=$(( $filenum+1  ))
	    else
		patchname=$1.$filenum
		touch $patchname
		diff -u $1.latest $2 > $patchname
		cp $2 $1.latest
		echo 'Committed a new version:'$filenum
		continuer=0
	    fi
	done
	echo -n $(date -R) >> $1.log
	echo " "$4 >> $1.log
	echo "" >> $1.log
    fi
    return 0
}
case_diff(){
    check_managed_file $1 $3
    cmp $2 $1.latest 1>/dev/null 2>&1
    filecmp=$?
    if [ $filecmp -eq 0 ]
    then
	echo '’'$3'’ is the latest version.'
	exit 1
    fi
    diff -u $2 $1.latest
    return 0
}
case_revert(){
    check_managed_file $1 $3
    cmp $2 $1.latest 1>/dev/null 2>&1
    filecmp=$?
    if [ $filecmp -eq 0 ]
    then
	echo '’'$3'’ is already the latest version.'
	exit 1
    fi
    cp $1.latest $2
    echo 'Reverted to the latest version.'
    return 0
}
case_rm(){
    check_managed_file $1 $3
    echo 'Are you sure you want to delete ’'$3'’ from versioning ? (yes/no)'
    read choice
    if [ "$choice" = "yes" ]
    then
	for file in $(ls $4 | grep $3.[0-9]*$ )
	do
	    rm -f $4/$file
	done
	if [ -f $1.log ]
	then
	    rm -f $1.log
	fi
	rm -f $1.latest
	testempty=$(ls $4|head -1)
	if [ -z "$testempty" ]
	then
	    rm -d $4
	fi
	echo '’'$3'’ is not under versioning anymore.'
    elif [ "$choice" = "no" ]
    then
	echo '’'$3'’not deleted from versioning.'
    else
	echo 'Not a valid choice.'
    fi
    return 0
}
case_log(){
    check_managed_file $1 $2
    if [ ! -f $1.log ]
    then
	echo 'No log found for ’'$2'’. Make at least one commit before trying to see the log'
	exit 1
    else
	nl $1.log
    fi
    
    return 0
}
#########################################################
# manage the commands
#########################################################
case $1 in
    add)
	case_add $vfile $2 $file
    ;;
    checkout)
	case_checkout $vfile $2 $3 $file
    ;;
    commit)
	case_commit $vfile $2 $file "$3"
    ;;
    diff)
	case_diff $vfile $2 $file
    ;;
    log) 
        case_log $vfile $file
    ;;
    revert)
	case_revert $vfile $2 $file
    ;;
    rm)	
	case_rm $vfile $2 $file $vdir
    ;;
    co)
	case_checkout $vfile $2 $3 $file
    ;;
    ci)
	case_commit $vfile $2 $3 $file
    ;;
    *) 
	echo 'Error! This command name does not exist: ’'$1'’'
    ;;
esac


