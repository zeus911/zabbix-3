#!/bin/bash
##########################################
# Version: 01a
#  Status: Not Functional
#   Notes: Under Development
#  Zabbix: 2.2 Stable
#      OS: Ubuntu/Debian 64-Bit
##########################################

CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON * . * TO 'zabbix'@'localhost';
FLUSH PRIVILEGES;
