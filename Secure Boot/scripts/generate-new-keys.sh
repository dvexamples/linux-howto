#!/bin/bash

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

#Request a password for new key
echo -n "Please input a password for a new key:" 
read -s PASSWORD
echo ""

echo -n "Please input the same password:" 
read -s CONFIRMATION_PASSWORD
echo ""

if [[ $PASSWORD != $CONFIRMATION_PASSWORD ]]; then
    echo "Wrong password"
    exit 1;
fi

$SCRIPTS_DIR/generate-new-key.sh PK <<<"$PASSWORD"
$SCRIPTS_DIR/generate-new-key.sh KEK <<<"$PASSWORD"
$SCRIPTS_DIR/generate-new-key.sh db <<<"$PASSWORD"
$SCRIPTS_DIR/generate-new-key.sh dbx <<<"$PASSWORD"
