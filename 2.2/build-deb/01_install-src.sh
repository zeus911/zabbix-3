#!/bin/bash
##########################################
# Version: 01a Alpha04
#  Status: Not Functional
#   Notes: Under Development
#  Zabbix: 2.2 Stable
#      OS: Ubuntu/Debian 64-Bit
##########################################

# Notes
# Make sure that Apache, MySQL, and PHP are installed!

# Installer variables
DOWNDIR="/tmp"
MYSQLUSER="root"
MYSQLPASS="password"
WWWPATH="/var/www/"  #Ubuntu 14.04 uses /var/www/html
VERSION="2.2.3"

# Verify LAMP is installed
echo "Verifying LAMP installation..."
dpkg --list > $DOWNDIR/dpkg.txt
if grep -q "apache" $DOWNDIR/dpkg.txt
	then	echo "...Apache installed"
	else    echo "...Apache not installed" && exit 0
fi
if grep -q "mysql" $DOWNDIR/dpkg.txt
        then    echo "...MySQL installed"
        else    echo "...MySQL not installed" && exit 0
fi
if grep -q "php" $DOWNDIR/dpkg.txt
        then    echo "...PHP installed"
        else    echo "...PHP not installed" && exit 0
fi

# Update OS
apt-get update && apt-get dist-upgrade -y && apt-get autoremove -y

# Required Packages
apt-get install build-essential mysql-client libmysqlclient-dev libsnmp-dev libcurl4-gnutls-dev php5-gd fping

# Download Source
wget --no-check-certificate -N http://softlayer-dal.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/$VERSION/zabbix-$VERSION.tar.gz -P $DOWNDIR/
tar -zxvf $DOWNDIR/zabbix-$VERSION.tar.gz
mv zabbix-$VERSION $DOWNDIR

# Add Zabbix user
groupadd zabbix
useradd -g zabbix zabbix

# Install Source
cd $DOWNDIR/zabbix-$VERSION
./configure --prefix=/usr/local/zabbix --enable-server --enable-agent --with-mysql --with-net-snmp --with-libcurl
make install

# MySQL Database
mysql -u$MYSQLUSER -p$MYSQLPASS -e "create database zabbix character set utf8 collate utf8_bin"
mysql -u$MYSQLUSER -p$MYSQLPASS zabbix -e "create table schema"
mysql -u$MYSQLUSER -p$MYSQLPASS zabbix < $DOWNDIR/zabbix-$VERSION/database/mysql/schema.sql
mysql -u$MYSQLUSER -p$MYSQLPASS zabbix < $DOWNDIR/zabbix-$VERSION/database/mysql/images.sql
mysql -u$MYSQLUSER -p$MYSQLPASS zabbix < $DOWNDIR/zabbix-$VERSION/database/mysql/data.sql

# Post Install Tweaks
ln -s /usr/bin/fping /usr/sbin/fping
sed -i 's/# PidFile=/PidFile=/g' /usr/local/zabbix/etc/zabbix_server.conf
sed -i 's/# PidFile=/PidFile=/g' /usr/local/zabbix/etc/zabbix_agentd.conf
mkdir $WWWPATH/zabbix
cp -a $DOWNDIR/zabbix-$VERSION/frontends/php/. $WWWPATH/zabbix
service apache2 restart


exit 0
