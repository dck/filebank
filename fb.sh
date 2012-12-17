#!/bin/bash

BANKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.bank"
HISTORY=$BANKDIR/history

if [ ! -e $BANKDIR ]
then
    mkdir $BANKDIR
fi

if [ ! -e $HISTORY ]
then
    touch $HISTORY
fi

MAXSIZE=$((10*1024*1024)) # bytes

remove()
{
    BANKSIZE=`du -bs $BANKDIR | cut -f1`
    for i in $@
    do
        if [ -e $BANKDIR/$i ];
        then
            echo "File $i already exists"
        else
            abs=$(readlink -f $i)
            mv $i $BANKDIR/$i
            echo "$i $abs" >> $HISTORY
        fi
    done
}
restore()
{
    echo "restore act."
}

out()
{
    echo "out act."
}
usage()
{
    echo "Usage: $0 <rm|restore|out> file1[,file2[,file3[,...]]]"
    echo "  rm      - remove file to filebank"
    echo "  restore - restore file from filebank"
    echo "  out     - remove file permanently"
    echo "  file    - the file :>"
    exit
}



case "$1" in
"rm")
    remove ${@:2}
    ;;
"restore")
    restore ${@:2}
    ;;
"out")
    out ${@:2}
    ;;
*)
    usage
    ;;
esac