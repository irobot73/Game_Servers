# LGSM

Scripts to assist running LGSM dedicated servers

## Back-Up

[HERE](https://github.com/irobot73/LGSM/tree/main/Backup)

- Linux back-up script that can be scheduled via CRON.

  > **NOTE:** Each LGSM server I run has it's own set of EXCLUDE/INCLUDE files. Each backup is as small & _COMPLETE_ as possible

  **CRON Example:**

      ## EVERY SUN @ 00:00 - Make sure to create [TOUCH] before using via redirect
      0 0 * * 0 /usr/bin/truncate --size 0 /data/log/crontab.log
      ## Execute every 6-hrs & log to 'crontab.log'
      0 */6 * * * /data/my_backup.sh >> /data/log/crontab.log 2>&1

<b>Come test 'em out (all details via Discord):</b>

- [Palworld](https://discord.gg/2jwYtw77hn)
- [Project Zomboid](https://discord.gg/hUsCvhXcst)
- [7 Days To Die](https://discord.gg/DEU5wmMvSn)
