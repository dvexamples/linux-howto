#!/bin/bash

#Print help if necessary
if [[ ($1 == "help") || ("$#" -ne 1) ]]; then
    echo 'Usage: <KEY_NAME>'
    exit 1
fi

KEY_AUTH_FILE=$1.auth

if [ ! -f $KEY_AUTH_FILE ]; then
    echo 'Can not find $KEY_AUTH_FILE'
    exit 1
fi

efi-updatevar -f $KEY_AUTH_FILEh PK
