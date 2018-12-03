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

#Validation

#Check key file
if [ ! -f "$KEY_FILE" ]; then
    echo "Can not find key file $KEY_FILE"
    exit 2
fi

#Check ESL file
if [ ! -f "$KEY_ESL_FILE" ]; then
    echo "Can not file $KEY_ESL_FILE"
    exit 3
fi

#Check CRT file
if [ ! -f "$KEY_CRT_FILE" ]; then
    echo "Can not certificate $KEY_CRT_FILE"
    exit 4
fi

#Self sign and create *.auth file
sign-efi-sig-list -k $KEY_FILE -c $KEY_CRT_FILE PK $KEY_ESL_FILE $KEY_AUTH_FILE

#Update platform key and tipping platform to User Mode
efi-updatevar -f $KEY_AUTH_FILE PK
