#!/bin/bash
##########################################
# Version: 08.05.15
#  Status: Functional
#   Notes: Under Development
#  Zabbix: 2.x Stable
#      OS: Ubuntu/Debian 64-Bit
##########################################

# Script variables
## Put your MySQL credentials after the script, ./zab2_src_install.sh current-user password new-user password
## example: ./zab2_src_install.sh root 123456 zabbix ABCDEF
MYSQLUSER=$1
MYSQLPASS=$2
NEWMYSQLUSER=$3
NEWMYSQLPASS=$4

# MySQL Database
$mysql -u$MYSQLUSER -p$MYSQLPASS -e "CREATE USER $NEWMYSQLUSER@localhost IDENTIFIED BY $NEWMYSQLPASS"
$mysql -u$MYSQLUSER -p$MYSQLPASS -e "GRANT ALL PRIVILEGES ON * . * TO $NEWMYSQLUSER@localhost"
$mysql -u$MYSQLUSER -p$MYSQLPASS -e "FLUSH PRIVILEGES"

exit 0
