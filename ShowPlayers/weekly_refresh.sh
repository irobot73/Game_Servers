#!/bin/bash
#set -x # Enable to DEBUG

# Find all the players, sort and get distinct, for the week
readarray -t players < <(grep -P '^(?!name).+,.+' /data/log/rcon.log  | sort | uniq)

# Loop through array and write NEW player info to the PLAYERS.LOG
for player in "${players[@]}"
do
	grep -q "${player}" /data/log/players.log
	if [ $? -gt "0" ]; then
		echo "${player}" >> /data/log/players.log
	fi
done

# Truncate the log files to start anew
/usr/bin/truncate --size 0 /data/log/crontab.log /data/log/rcon.log
