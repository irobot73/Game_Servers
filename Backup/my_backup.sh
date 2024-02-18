#!/bin/bash

#set -x # Enable to DEBUG

BACKUP_PATH=/data/backup
FILE_TYPE="D" # Use '(D)AY' or '(T)IMESTAMP'
NUM_DAYS_KEEP=3 # Only used with TIMESTAMP backups
EXCLUDE_FILE="/data/bkup_exclude.txt"
INCLUDE_FILE="/data/bkup_include.txt"
# Do not edit unless you know what you are doing
BACKUP=""
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

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

Backup() {
    local exclude_param
    exclude_param=""
    local include_param
    include_param=""
    
    if [ -f "$EXCLUDE_FILE" ]; then
        exclude_param="-X ${EXCLUDE_FILE}"
    fi

    if [ -f "$INCLUDE_FILE" ]; then
        include_param="-T ${INCLUDE_FILE}"
    fi

    tar -czf "${BACKUP}" -C / ${exclude_param} ${include_param}
    
    return $?
}

# Gives some head read to more easily read in output (log+)
echo

GenerateBackupFileName
CleanUp

# Do work
echo "Creating backup: '${BACKUP}'"

exitcode=$(Backup)

# Give final status
echo "Finished.  Exit Code: ${exitcode}, Size $(du -sh "${BACKUP}" | awk '{print $1}')"
