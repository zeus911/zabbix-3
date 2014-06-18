#!/bin/bash
##########################################
# Version: 01a
#  Status: Functional
#   Notes: Under Development
#  Zabbix: 2.2 Stable
#      OS: Ubuntu/Debian 64-Bit
##########################################

# PHP Tweaks
cp /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.orig
sed -i 's/post_max_size = 8M/post_max_size = 16M/g' /etc/php5/apache2/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php5/apache2/php.ini
sed -i 's/max_input_time = 60/max_input_time = 300/g' /etc/php5/apache2/php.ini
service apache2 restart


exit 0
