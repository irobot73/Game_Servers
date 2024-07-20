#!/bin/bash

#source rcon_pw_secrets.txt

cd /data/RCON

CNTDOWN="${2}-min"

if (( $2 > 1 )); then
   CNTDOWN+="s"
fi

OUTPUT=$(./rcon -e "$1" -c ./rcon.yaml "servermsg \"REBOOTING in ${CNTDOWN}\"")

echo "${OUTPUT}"
