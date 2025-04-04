# utils-scripts

#cron proxmox config 
0 1 * * * /UTILS/backup-proxmox-config-cron.sh > /dev/null 2>> /UTILS/log/proxmox_backup.log