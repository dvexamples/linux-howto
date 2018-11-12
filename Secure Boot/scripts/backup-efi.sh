#!/bin/bash


#Print help if necessary
if [[ ($1 == "help") || ("$#" -ne 1) ]]; then
    echo 'Usage: <KEY_NAME>'
    exit 1
fi
