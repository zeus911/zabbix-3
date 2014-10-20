#!/bin/bash
FILE='/tmp/zabbix_server.pid'
FILE2='/tmp/zabbix_agentd.pid'

if [ -f $FILE2 ];
then
   echo "Zabbix agent already running."
else
   /usr/local/sbin/zabbix_agentd
fi

if [ -f $FILE ];
then
   echo "Zabbix server already running."
else
   /usr/local/sbin/zabbix_server
fi

exit 0
