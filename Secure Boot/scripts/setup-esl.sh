#!/bin/bash

#Print help if necessary
if [[ ($1 == "help") || ("$#" -ne 4) || ($1 != "PK" && $1 != "KEK" && $1 != "db" && $1 != "dbx") ]]; then
    echo 'Usage: <KEK|db|dbx> <KEY.FILE> <CERTIFICATE.FILE> <FILE.esl>'
    exit 1
fi

#Parameters
VARIABLE=$1
KEY_FILE=$2
CERT_FILE=$3
ESL_FILE=$4



#Check ESL file
if [ ! -f "$ESL_FILE" ]; then
    echo "Can not find file $ESL_FILE"
    exit 2
fi

#Update variable with new esl
efi-updatevar -e -f $ESL_FILE $VARIABLE
