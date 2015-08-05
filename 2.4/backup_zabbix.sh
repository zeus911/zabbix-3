#!/bin/bash
##########################################
# Version: 08.05.15
#  Status: Functional
#   Notes: Writing a backup script
##########################################

# Beginning Script Message
clear
echo && echo "Welcome to the Zabbix Backup script for Ubuntu" && echo

# Script Variables
DATE=$(date +%Y%m%d_%H%M)
DBUSER="user"
DBPASS="password"
BACKUPLOC=/home/cnc-admin/zabbix-backups

# Stop Zabbix
echo "...Stopping Zabbix"
kill1="killall zabbix_agentd"
kill2="killall zabbix_server"
$kill1
$kill2
sleep 5
$kill1
$kill2
sleep 5
$kill1
$kill2
sleep 5
$kill1
$kill2

# Directory Backup
echo "...Starting Directory Backup"
mkdir -p $BACKUPLOC/tar
tar --exclude backups --exclude perf --exclude log -czf $BACKUPLOC/tar/zenoss_backup_$DATE.tgz /var/www

# MySQL Backup
echo "...Starting MySQL Backup"
mkdir -p $BACKUPLOC/sql
mysqldump -u$DBUSER -p$DBPASS zabbix > $BACKUPLOC/sql/zabbix_$DATE.sql

# Start Zabbix
echo "...Starting Zabbix"
zabbix_agentd
zabbix_server

echo && echo "The Zabbix Backup script is complete!!!" && echo

exit 0
            
