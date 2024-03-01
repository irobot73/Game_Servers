# LGSM

## RCON

**(Palworld) CRON Example:**

      ## EVERY SUN @ 00:00
      # 0 0 * * 0 /usr/bin/truncate --size 0 /data/log/crontab.log /data/log/rcon.log
      ## EVERY DAY @ 04:00
      # 1 4 * * * /data/RCON/rcon_send_backup_msg.sh zomboid 1 >> /data/log/crontab.log 2>&1
      # 2 4 * * * /data/my_backup.sh >> /data/log/crontab.log 2>&1
      ## EVERY Tu,Th,Sa @ 04:30
      # 0 4 * * 2,4,6 /data/RCON/rcon_send_reboot_msg.sh zomboid 30 >> /data/log/crontab.log 2>&1
      # 15 4 * * 2,4,6 /data/RCON/rcon_send_reboot_msg.sh zomboid 15 >> /data/log/crontab.log 2>&1
      # 20 4 * * 2,4,6 /data/RCON/rcon_send_reboot_msg.sh zomboid 10 >> /data/log/crontab.log 2>&1
      # 25 4 * * 2,4,6 /data/RCON/rcon_send_reboot_msg.sh zomboid 5 >> /data/log/crontab.log 2>&1
      # 29 4 * * 2,4,6 /data/RCON/rcon_send_reboot_msg.sh zomboid 1 >> /data/log/crontab.log 2>&1
      # 30 4 * * 2,4,6 /app/*server restart >> /data/log/crontab.log 2>&1
