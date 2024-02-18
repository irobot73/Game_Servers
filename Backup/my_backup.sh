#!/bin/bash

#set -x # Enable to DEBUG

BACKUP_PATH=/data/backup
FILE_TYPE="D" # Use '(D)AY' or '(T)IMESTAMP'
NUM_DAYS_KEEP=3 # Only used with TIMESTAMP backups
BACKUP="" # Do not edit unless you know what you are doing

IsFileTypeDay() {
    local pat="^(d|D)"    
    if [[ "$FILE_TYPE" =~ $pat ]]; then
        return 0 # true
    else 
        return 1 # false
    fi
}

GenerateBackupFileName() {
  local backupfilename  
  if IsFileTypeDay; then
    backupfilename=lgsm_$(date -d "today" +"%A").tar.gz
  else
    backupfilename=lgsm_$(date +%Y%m%d_%H%M%S).tar.gz
  fi  
  BACKUP="${BACKUP_PATH}/${backupfilename}"
}

CleanUp() {
  if IsFileTypeDay; then 
    if [ -f "${BACKUP}" ]; then # Remove existing DAY file
      echo "Existing backup detected.  Removing."
      rm -fv "${BACKUP}"
    fi
  else # Remove older TimeStamp based backups
    find "$BACKUP_PATH" -name "*.tar.gz" -type f -mtime +$NUM_DAYS_KEEP -print0 | xargs -r -0 rm -fv
  fi
}

# Gives some head read to more easily read in output (log+)
echo

GenerateBackupFileName
CleanUp

echo "Creating backup: '${BACKUP}'"

tar -czf "${BACKUP}" -C / -X /data/bkup_exclude.txt -T /data/bkup_include.txt
exitcode=$?

echo "Finished.  Exit Code: ${exitcode}, Size $(du -sh "${BACKUP}" | awk '{print $1}')"
