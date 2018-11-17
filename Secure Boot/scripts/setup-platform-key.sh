#!/bin/bash

#Print help if necessary
if [[ ($1 == "help") ]]; then
    echo 'Usage: [KEY_NAME]'
    exit 1
fi

#Parameters
KEY_NAME="$1"
if [[ "$#" -ne 1 ]]; then
    KEY_NAME="PK"
fi

#Files
KEY_FILE="$KEY_NAME.key"
KEY_CRT_FILE="$KEY_NAME.crt"
KEY_ESL_FILE="$KEY_NAME.esl"
KEY_AUTH_FILE="$KEY_NAME.auth"

sign-efi-sig-list -k $KEY_FILE -c $KEY_CRT_FILE PK $KEY_ESL_FILE $KEY_AUTH_FILE

efi-updatevar -f $KEY_AUTH_FILE PK
