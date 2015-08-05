#!/bin/bash
##########################################
# Version: 08.05.15
#  Status: Functional
#   Notes: Under Development
#  Zabbix: 2.2 Stable
#      OS: Ubuntu/Debian 64-Bit
##########################################

# Beginning Script Message
clear
echo && echo "Welcome to the Zabbix install script for Ubuntu and Debian!" && echo
echo "*WARNING*: This script will update your OS."
echo "           Make sure to make a backup and/or take a snapshot!" && echo && sleep 5
echo "...Begin, we will, learn you must." && sleep 1

# Installer variables
DOWNDIR=~/tmp
## Put your MySQL credentials after the script, ./zab2_src_install.sh root password
MYSQLUSER=$1
MYSQLPASS=$2
VERSION="2.4.4"

# Update OS
apt-get update

# Required Packages
apt-get install mysql-server mysql-client build-essential libmysqlclient-dev libsnmp-dev libcurl4-gnutls-dev php5-gd fping nmap traceroute

# Download Source
mkdir $DOWNDIR
wget --no-check-certificate -N http://iweb.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/$VERSION/zabbix-$VERSION.tar.gz -P $DOWNDIR/
tar -zxvf $DOWNDIR/zabbix-$VERSION.tar.gz
mv zabbix-$VERSION $DOWNDIR

# Add Zabbix user
groupadd zabbix
useradd -g zabbix zabbix

# Install Source
cd $DOWNDIR/zabbix-$VERSION
./configure --enable-proxy --enable-agent --with-mysql --with-net-snmp --with-libcurl
make install

# MySQL Database
mysql -u$MYSQLUSER -p$MYSQLPASS -e "create database zabbix character set utf8 collate utf8_bin"
mysql -u$MYSQLUSER -p$MYSQLPASS zabbix < $DOWNDIR/zabbix-$VERSION/database/mysql/schema.sql
mysql -u$MYSQLUSER -p$MYSQLPASS zabbix < $DOWNDIR/zabbix-$VERSION/database/mysql/images.sql
mysql -u$MYSQLUSER -p$MYSQLPASS zabbix < $DOWNDIR/zabbix-$VERSION/database/mysql/data.sql

# Post Install Tweaks
ln -s /usr/bin/fping /usr/sbin/fping
#sed -i 's/# PidFile=/PidFile=/g' /usr/local/etc/zabbix_server.conf
#sed -i 's/# PidFile=/PidFile=/g' /usr/local/etc/zabbix_agentd.conf

exit 0
