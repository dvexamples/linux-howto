#!/bin/bash

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

#Print help if necessary
if [[ ($1 == "help") ]]; then
    echo 'Usage: [PREFIX]'
    exit 1
fi

#Parameters
PREFIX="$1"

#Backup all variables
$SCRIPTS_DIR/backup-efi-variable.sh PK $PREFIX
$SCRIPTS_DIR/backup-efi-variable.sh KEK $PREFIX
$SCRIPTS_DIR/backup-efi-variable.sh db $PREFIX
$SCRIPTS_DIR/backup-efi-variable.sh dbx $PREFIX


