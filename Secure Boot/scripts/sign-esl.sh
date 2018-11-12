#!/bin/bash

#Print help if necessary
if [[ ($1 == "help") || ("$#" -ne 3) || ($2 != "PK" && $2 != "KEK" && $2 != "DB") ]]; then
    echo 'Usage: <KEY_NAME> <PK|KEK|DB> <TARGET_KEY_NAME>'
    exit 1
fi

KEY_NAME=$1
TARGET_KEY_NAME=$2,

#Private key and certificate)
KEY_FILE=$KEY_NAME.key
KEY_CERTIFICATE_FILE=$KEY_NAME.crt

#Type
KEY_TYPE=$2

#Key to be signed in a form of *.esl file
TARGET_FILE=$3.esl
OUTPUT_FILE=$3.auth

if [ ! -f $KEY_FILE ]; then
    echo "Can't find key: $KEY_FILE"
    exit 2
fi

if [ ! -f $KEY_CERTIFICATE_FILE ]; then
    echo "Can't find key certificate: $KEY_CERTIFICATE_FILE"
    exit 2
fi

if [ ! -f $TARGET_FILE ]; then
    echo "Can't find target ESL file: $TARGET_FILE"
    exit 2
fi

sign-efi-sig-list -k $KEY_FILE -c $KEY_CERTIFICATE_FILE $KEY_TYPE $TARGET_FILE $OUTPUT_FILE  
