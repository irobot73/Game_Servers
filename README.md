# Palworld

Scripts to assist running a dedicated (Windows) Palworld server

# LGSM

Scripts to assist running LGSM dedicated servers

## Back-Up

[HERE](https://github.com/irobot73/LGSM/tree/main/Backup)

- Back-up script that can be scheduled via CRON.

  > **NOTE:** Each LGSM server I run has it's own set of EXCLUDE/INCLUDE files. Each backup is as small & _COMPLETE_ as possible

  **CRON Example:**

      ## https://crontab.guru/ [to create/verify]
      #
      ## Every SUN @ 00:00 - Make sure to create [TOUCH] before using via redirect
      0 0 * * 0 /usr/bin/truncate --size 0 /data/log/crontab.log
      ## Every 30-mins past every 6th hour [00:30, 06:30, 12:30, 18:30] & log to 'crontab.log'
      30 */6 * * * /data/my_backup.sh >> /data/log/crontab.log 2>&1

## Weekly Refresh

[HERE](https://github.com/irobot73/LGSM/tree/main/ShowPlayers)

- Player tracker and log cleaner script that can be scheduled via CRON.

## Discord
<b>Come test 'em out:</b>

- [Palworld](https://discord.gg/2jwYtw77hn)
- [Project Zomboid](https://discord.gg/hUsCvhXcst)
- [7 Days To Die](https://discord.gg/DEU5wmMvSn)
