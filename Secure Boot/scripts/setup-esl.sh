#!/bin/bash

#Print help if necessary
if [[ ($1 == "help") || ("$#" -ne 2) ]]; then
    echo 'Usage: <FILE.esl> <KEK|DB>'
    exit 1
fi

ESL_FILE=$1
VARIABLE=$2

if [ ! -f "$ESL_FILE" ]; then
    echo "Can not find file $ESL_FILE"
    exit 2
fi

#Update variable with new esl
efi-updatevar -e -f $ESL_FILE $VARIABLE
