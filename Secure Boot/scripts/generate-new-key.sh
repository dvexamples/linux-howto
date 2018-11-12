#!/bin/bash

#Print help if necessary
if [[ ($1 == "help") || ("$#" -ne 1) ]]; then
    echo 'Usage: <KEY_NAME>'
    exit 1
fi

KEY_NAME=$1

#Request a password for new key
echo -n "Please input a password for a new key:" 
read -s PASSWORD

#Generate new key pair
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=$KEY_NAME/" -keyout $KEY_NAME.key -out $KEY_NAME.crt -days 3650 -sha256 -passout stdin <<< "$PASSWORD"

# Uncomment this if you need DER version
#openssl x509 -outform DER -in $KEY_NAME.crt  -out $KEY_NAME.cer 

#Convert PEM to EFI signature list
cert-to-efi-sig-list -g "$(uuidgen)" $KEY_NAME.crt $KEY_NAME.esl


