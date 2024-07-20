Scripts to assist running LGSM dedicated servers

## Weekly Refresh

[HERE](https://github.com/irobot73/LGSM/tree/main/ShowPlayers)

- Linux BASH script that can be scheduled via CRON.  It will parse the RCON log file for any (current|prior) players on the server.  It will then compare that list to an existing PLAYERS.LOG and write the player data if it does not already exist.  The script will then clear out the log files.

  **CRON Example:**

      ## https://crontab.guru/ [to create/verify]
      #
      ## Execute Palworld's 'ShowPlayers' RCON command
      4,16,32,49 * * * * /data/RCON/rcon -e palworld -c /data/RCON/rcon.yaml ShowPlayers
      ## EVERY SUN @ 00:00      
      # 0 0 * * 0 /data/weekly_refresh.sh

  **RCON Output Example:**

      [2024-03-08 23:49:01] 127.0.0.1:8213: ShowPlayers
      name,playeruid,steamid
      i_robot73,218730312,76561197978948986
