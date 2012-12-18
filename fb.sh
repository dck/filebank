#!/bin/bash

BANKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.bank"
# HISTORY=history
# HISTORYPATH=$BANKDIR/$HISTORY
MAXSIZE=$((10*1024*1024))  # bytes

if [ ! -e $BANKDIR ]
then
    mkdir $BANKDIR
fi

# if [ ! -e $HISTORYPATH ]
# then
#     touch $HISTORYPATH
# fi



remove()
{
    for i in $@
    do
        [ -e $i ] || continue
        banksize=`du -bs $BANKDIR | cut -f1`
        filesize=`du -bs $i | cut -f1`
        totalsize=$(($filesize+$banksize))
        if [ $totalsize -gt $MAXSIZE ];
        then
            echo "Bask size is too much"
            exit 1
        else
            if [ -e $BANKDIR/$i ];
            then
                echo "File $i already exists"
            else
                abs=$(readlink -f $i)
                mv $i $BANKDIR/$i
                # echo "$i $abs" >> $HISTORYPATH
            fi
        fi

    done
}
restore()
{
    for i in $@
    do
        if [ -e $BANKDIR/$i ];
        then
            mv $BANKDIR/$i `pwd`/$i
        else
            echo "File $i not found in bank"
        fi

    done
}

out()
{
    for i in $@
    do
        rm $i
    done
}

list()
{
    ls -lh $BANKDIR | awk 'NF>2' | awk '{printf "%-20s %5s\n",$9, $5}'
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
"list")
    list ${@:2}
    ;;
*)
    usage
    ;;
esac