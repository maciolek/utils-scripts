# utils-scripts

# update & upgrade proxmox server [At 06:00 on Wednesday]
0 6 * * 3 /usr/bin/apt update && /usr/bin/apt full-upgrade -y && [ -f /var/run/reboot-required ] && /sbin/reboot >> /UTILS/log/proxmox-upgrade.log 2>&1

# update & upgrade all LXC [At 06:00 on Thursday]
0 6 * * 4 PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /bin/bash /UTILS/update-lxcs-cron.sh >> /UTILS/log/update-lxcs-cron.log 2>&1

# backup proxmox config [every day at 0.30 ]
30 0 * * * /UTILS/backup-proxmox-config-cron.sh > /dev/null 2>> /UTILS/log/proxmox_backup.log