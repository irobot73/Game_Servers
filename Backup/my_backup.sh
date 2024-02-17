#!/bin/bash

#set -x
#shopt -s extglob # enabled for extended pattern matching operators to be recognised.

BACKUP_PATH=/data/backup
FILE_TYPE="D" # Use '(D)AY' or '(T)IMESTAMP'
NUM_DAYS_KEEP=3 # Only used with TIMESTAMP backups
BACKUP="" # Do not edit unless you know what you are doing

# EG: lgsm_(Monday|Tuesday|...|Sunday).tar.gz
UseDayNamesForFiles() {
  local backupfilename
  backupfilename=lgsm_$(date -d "today" +"%A").tar.gz
  BACKUP="${BACKUP_PATH}/${backupfilename}"
}

# EG: lgsm_20240201_062111.tar.gz
UseTimestampForFiles() {
  local backupfilename
  backupfilename=lgsm_$(date +%Y%m%d_%H%M%S).tar.gz
  BACKUP="${BACKUP_PATH}/${backupfilename}"
}

IsFileTypeDay() {
    local pat="^(d|D)"
    if [[ "$FILE_TYPE" =~ $pat ]]; then
        return 0 # true
    else 
        return 1 # false
    fi
}

CleanUp() {
  if IsFileTypeDay; then 
    if [ -f "${BACKUP}" ]; then # Remove existing DAY file
      echo "Existing backup detected.  Removing."
      rm -v "${BACKUP}"
    fi
  else # Remove older TimeStamp based backups
    find "$BACKUP_PATH" -name "*.tar.gz" -type f -mtime +$NUM_DAYS_KEEP -print0 | xargs -r -0 rm -v
  fi
}

Setup() {
  if IsFileTypeDay; then
    UseDayNamesForFiles
  else
    UseTimestampForFiles
  fi
}

Setup
CleanUp

echo "Creating backup: '${BACKUP}'"

tar -czf "${BACKUP}" -C / -X /data/bkup_exclude.txt -T /data/bkup_include.txt
exitcode=$?

echo "Finished.  Exit Code: ${exitcode}, Size $(du -sh "${BACKUP}" | awk '{print $1}')"
