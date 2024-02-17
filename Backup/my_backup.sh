#!/bin/sh

BACKUP_PATH=/data/backup
BACKUP_INCLUDE_FILE=/data/bkup_include.txt
NUM_DAYS_KEEP=3

echo
echo "Starting backup..."

## Purge ( > # days ) Only run REMOVE if there are any files found

find "$BACKUP_PATH" -name "*.tar.gz" -type f -mtime +$NUM_DAYS_KEEP | xargs rm -v -r

## Setup ##

FILENAME=lgsm_$(date +%Y%m%d_%H%M%S).tar.gz # lgsm_20240201_062111.tar.gz
#FILENAME=lgsm_$(date -d "today" +"%A").tar.gz # lgsm_(Monday|Tuesday|...|Sunday).tar.gz
BACKUP="${BACKUP_PATH}/${FILENAME}"

## Backup ##

tar -czf "${BACKUP}" -C / -T "${BACKUP_INCLUDE_FILE}

exitcode=$?

echo "Completed: '${BACKUP}', Exit Code: ${exitcode}, Size $(du -sh "${BACKUP}" | awk '{print $1}')"
