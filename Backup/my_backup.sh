#!/bin/bash

#set -x # Enable to DEBUG

BACKUP_PATH=/data/backup
FILE_TYPE="T" # Use '(D)AY' or '(T)IMESTAMP'
NUM_DAYS_KEEP=3 # Only used with TIMESTAMP backups
EXCLUDE_FILE="/data/bkup_exclude.txt"
INCLUDE_FILE="/data/bkup_include.txt"
# Do not edit unless you know what you are doing
BACKUP=""
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
# Defaults if/when the EXCLUDE file is empty/missing
EXCLUDE_PARAM_DEFAULTS="--exclude=backup --exclude=lgsm --exclude=log --exclude=steamapps --exclude='.*' --exclude='*.lock'"
# Defaults if/when the INCLUDE file is empty/missing
INCLUDE_PARAM_DEFAULTS="/data /app"

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

    # Check if the file(s) exist & have a file size
    if [[ -f $EXCLUDE_FILE && -s $EXCLUDE_FILE ]]; then
        exclude_param="-X ${EXCLUDE_FILE}"
    else
        exclude_param=$EXCLUDE_PARAM_DEFAULTS
    fi

    #  If invalid, we'll make it so the backup doesn't start at the root level
    if [[ -f $INCLUDE_FILE && -s $INCLUDE_FILE ]]; then
        include_param="-T ${INCLUDE_FILE}"
    else
        include_param=$INCLUDE_PARAM_DEFAULTS
    fi


    tar -czf "${BACKUP}" -C . --exclude-vcs --ignore-failed-read ${exclude_param} ${include_param} .

    echo $?
}

# Gives some head read to more easily read in output (log+)
echo

GenerateBackupFileName
CleanUp

# Do work
echo "Creating backup: '${BACKUP}'"

exitcode=$(Backup)

# Give final status
if [[ $exitcode -eq 0 ]]; then
    if [[ -n ${BACKUP} && -f ${BACKUP} ]]; then
        echo "Finished.  Exit Code: ${exitcode}, Size $(du -sh "${BACKUP}" | awk '{print $1}')"
    else
        exit 99
    fi
else
    echo "Backup failed.  Exit code: '$exitcode'"
fi
