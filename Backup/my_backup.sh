#!/bin/bash
# https://github.com/irobot73/LGSM

#set -x # Enable to DEBUG

# Change the following as needed
BACKUP_PATH="/data/backup"
FILE_TYPE="D"   # Use '(D)AY' or '(T)IMESTAMP'
NUM_DAYS_KEEP=3 # Only used with TIMESTAMP backups
EXCLUDE_FILE="${DIR}/bkup_exclude.txt"
INCLUDE_FILE="${DIR}/bkup_include.txt"

# WARNING:  Do not edit unless you know what you are doing
BACKUP=""
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
# Defaults if/when the EXCLUDE file is empty/missing
EXCLUDE_PARAM_DEFAULTS=("backup" "lgsm" "log" "steamapps" "*.lock" ".*")
# Defaults if/when the INCLUDE file is empty/missing
INCLUDE_PARAM_DEFAULTS=("/data" "/app")

IsFileTypeDay() {
    local pat="^(d|D)"
    if [[ "$FILE_TYPE" =~ $pat ]]; then
        return 0 # true
    else
        return 1 # false
    fi
}

DependencyChecks() {
    if [[ ! -d ${BACKUP_PATH} ]]; then
        mkdir "${BACKUP_PATH}"
    fi

    if ! [[ -f $EXCLUDE_FILE && -s $EXCLUDE_FILE ]]; then
        touch "${EXCLUDE_FILE}"
        printf '%s\n' "${EXCLUDE_PARAM_DEFAULTS[@]}" >>"${EXCLUDE_FILE}"
    fi

    if ! [[ -f $INCLUDE_FILE && -s $INCLUDE_FILE ]]; then
        touch "${INCLUDE_FILE}"
        printf '%s\n' "${INCLUDE_PARAM_DEFAULTS[@]}" >>"${INCLUDE_FILE}"
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
    local exitcode
    local error_result

    echo "Creating backup: '${BACKUP}'"

    tar -czf "${BACKUP}" -C . --exclude-vcs --ignore-failed-read -X "${EXCLUDE_FILE}" -T "${INCLUDE_FILE}" .
    exitcode=$?

    error_result="Backup failed.  Exit code: '$exitcode'"

    # Give final status
    if [[ $exitcode -eq 0 ]]; then
        if [[ -n ${BACKUP} && -f ${BACKUP} ]]; then
            echo "Finished.  Exit Code: ${exitcode}, Size $(du -sh "${BACKUP}" | awk '{print $1}')"
        else
            echo "${error_result}"
        fi
    else
        echo "${error_result}"
    fi
}

# Gives some head read to more easily read in output (log+)
echo

DependencyChecks
GenerateBackupFileName
CleanUp
Backup
