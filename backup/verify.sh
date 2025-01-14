#!/bin/bash

# Backup disk as splitted compressed files

# PARAMETERS
BACKUP=$1

# Variables
CURRENT_DATE=$(date +"%s")
BACKUP_FOLDER="$BACKUP"
ORIGINAL_CHECKSUM_FILE="$BACKUP_FOLDER/checksum.md5"
CHUNKS_CHECKSUMS_FILE="$BACKUP_FOLDER/checksums.md5"
CHUNK_FILE_PREFIX="$BACKUP_FOLDER/data.gz."

TOTAL_SIZE=$(du -sb $BACKUP_FOLDER | awk '{print $1}')

# Print details
echo "Verify Backup: $BACKUP_FOLDER"
echo "Chunks Size:$TOTAL_SIZE"
# 0. INIT
#mkdir "$BACKUP_FOLDER"
if [ -z "$(ls -A $BACKUP_FOLDER)" ]; then
    echo "The folder is empty"
    exit 1
fi


echo "Verify beckup..."
cat "$CHUNK_FILE_PREFIX"* | pv -s $TOTAL_SIZE | gunzip -c | md5sum --check "$ORIGINAL_CHECKSUM_FILE"


END_TIME=$(date +%s)
EXECUTION_TIME=$((END_TIME-START_TIME))
echo "Execution Time: $(date -u -d @${EXECUTION_TIME} +%H:%M:%S)"
