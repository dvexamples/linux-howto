#!/bin/bash

# Backup disk as splitted compressed files

# PARAMETERS
SOURCE=$1
BACKUP=$2

# Variables
CURRENT_DATE=$(date +"%s")
BACKUP_FOLDER="$BACKUP"
CHUNK_FILE_PREFIX="$BACKUP_FOLDER/data.gz."

SOURCE_SIZE=$(sudo blockdev --getsize64 "$SOURCE")
START_TIME=$(date +%s)

# Print details

echo "Back up creation: $SOURCE"
echo "Source Size: $SOURCE_SIZE"
echo "Backup: $BACKUP_FOLDER"

# 0. INIT
#mkdir "$BACKUP_FOLDER"
if [ -z "$(ls -A $BACKUP_FOLDER)" ]; then
    echo ""
else
    echo "The folder is not empty"
    exit 1
fi

# Copy, compress and split data
echo "Backuping..."
dd if=$SOURCE | pv -s $SOURCE_SIZE | gzip -c -v9 | split -a4 -b1G - "$CHUNK_FILE_PREFIX"

END_TIME=$(date +%s)
EXECUTION_TIME=$((END_TIME-START_TIME))
echo "Execution Time: $(date -u -d @${EXECUTION_TIME} +%H:%M:%S)"
