#!/bin/bash
##########################################
# Version: 01a Alpha02
#  Status: Not Functional
#   Notes: Under Development
#  Zabbix: 2.2 Stable
#      OS: Ubuntu/Debian 64-Bit
##########################################

# Notes
# Make sure that Apache, MySQL, and PHP are installed!

# Installer variables
DOWNDIR="/tmp"

# Update OS
apt-get update && apt-get dist-upgrade -y && apt-get autoremove -y

# Required Packages
apt-get install build-essential mysql-client libmysqlclient-dev libsnmp-dev libcurl4-gnutls-dev php5-gd fping

# Download Source
wget http://softlayer-dal.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.2.3/zabbix-2.2.3.tar.gz
tar -zxvf zabbix-2.*tar.gz

# Add Zabbix user
groupadd zabbix
useradd -g zabbix zabbix

# Install Source
cd zabbix-2.*
./configure --enable-server --enable-agent --with-mysql --with-net-snmp --with-libcurl
make install

# MySQL Databases
mysql -uroot -p
create database zabbix character set utf8 collate utf8_bin;
quit;
mysql -uroot -p zabbix < database/mysql/schema.sql
mysql -uroot -p zabbix < database/mysql/images.sql
mysql -uroot -p zabbix < database/mysql/data.sql

# Notes
ln -s /usr/bin/fping /usr/sbin/fping
adjust zabbix_server.conf -> uncomment and delete space before: PidFile=/tmp/zabbix_server.pid (same for agentd)
cp -a frontends/php/. /var/www/html
Adjust php variables
service apache2 restart


exit 0
