#!/bin/bash


#Print help if necessary
if [[ ($1 == "help") || ("$#" < 1) || ($1 != "PK" && $1 != "KEK" && $1 != "db" && $1 != "dbx")]]; then
    echo 'Usage: <PK|KEK|db|dbx> [PREFIX]'
    exit 1
fi

#Parameters
VARIABLE=$1
PREFIX=$2

#File name pattern
if [[ "$PREFIX" == "" ]]; then
    CURRENT_ESL_FILE="$VARIABLE.esl"
    PREVIOUS_ESL_FILE="$VARIABLE-$(date '+%d-%m-%Y-%H%M%S');.esl"
else
    CURRENT_ESL_FILE="$PREFIX-$VARIABLE.esl"
    PREVIOUS_ESL_FILE="$PREFIX-$VARIABLE-$(date '+%d-%m-%Y-%H%M%S').esl"
fi

#Archive existing file
if [ -f $CURRENT_ESL_FILE ]; then
    mv $CURRENT_ESL_FILE $PREVIOUS_ESL_FILE
fi

#Store variable
efi-readvar -v $VARIABLE -o $CURRENT_ESL_FILE

