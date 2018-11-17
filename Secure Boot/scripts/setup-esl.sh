#!/bin/bash

#Print help if necessary
if [[ ($1 == "help") || ("$#" -ne 2) || ($1 != "PK" && $1 != "KEK" && $1 != "db" && $1 != "dbx") ]]; then
    echo 'Usage: <KEK|db|dbx> <FILE.esl>'
    exit 1
fi

#Parameters
VARIABLE=$1
ESL_FILE=$2

#Check ESL file
if [ ! -f "$ESL_FILE" ]; then
    echo "Can not find file $ESL_FILE"
    exit 2
fi

#Update variable with new esl
efi-updatevar -e -f $ESL_FILE $VARIABLE
