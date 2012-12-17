#!/bin/bash

BANKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.bank"
cd $BANKDIR
find -not -name "history" -ctime +7 -exec rm '{}' \; 