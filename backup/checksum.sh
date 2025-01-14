#!/bin/bash

# Backup disk as splitted compressed files

# PARAMETERS
SOURCE=$1
BACKUP=$2

# Variables
CURRENT_DATE=$(date +"%s")
BACKUP_FOLDER="$BACKUP"
ORIGINAL_CHECKSUM_FILE="$BACKUP_FOLDER/checksum.md5"
CHUNKS_CHECKSUMS_FILE="$BACKUP_FOLDER/checksums.md5"

SOURCE_SIZE=$(sudo blockdev --getsize64 "$SOURCE")
START_TIME=$(date +%s)

# Print details
echo "Checksum creation: $SOURCE"
echo "Source Size: $SOURCE_SIZE"
echo "Backup: $BACKUP_FOLDER"

# 0. INIT
#mkdir "$BACKUP_FOLDER"
if [ -z "$(ls -A $BACKUP_FOLDER)" ]; then
    echo "The folder is empty"
    exit 1
fi

#Compute checksum of every chunk
echo "Chunks checksum computing..."
files=($BACKUP_FOLDER/*)
total=${#files[@]}
count=0

for file in "${files[@]}"; do
    md5sum "$file" >> $CHUNKS_CHECKSUMS_FILE
    ((count++))
    echo "Computing [$count/$total]: $file"
done


# Copy, compress and split data
echo "Source checksum computing..."
dd if=$SOURCE | pv -s $SOURCE_SIZE | md5sum > "$ORIGINAL_CHECKSUM_FILE"



END_TIME=$(date +%s)
EXECUTION_TIME=$((END_TIME-START_TIME))
echo "Execution Time: $(date -u -d @${EXECUTION_TIME} +%H:%M:%S)"
