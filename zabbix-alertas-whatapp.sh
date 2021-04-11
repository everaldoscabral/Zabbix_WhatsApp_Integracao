#!/bin/bash
ENTER="
";
HORA=$(date +%d-%m-%Y-%H:%M:%S)
RECIPIENT_NUMBER="$1"
YOWSEXEC="/usr/lib/zabbix/alertscripts/yowsup-master/yowsup-cli"
CONF="/etc/zabbix/zap.conf"
LOG="/tmp/whatsapp.log"
MESSAGE=$(echo -e "$2")

# Loop to try until message sent correctly
COUNT=1
while [ $COUNT -le 10 ]; do

   echo -e "$HORA - Start message send (attempt $COUNT) ..." >> $LOG
   echo -e "$HORA - $MESSAGELOG" >> $LOG

   while [ $(ps -ef | grep yowsup | grep -v grep | wc -l) -eq 1 ]; do
      echo -e "$HORA - Yowsup still running, waiting 2 seconds before a new try ..." >> $LOG
      sleep 2; 
   done;

   $YOWSEXEC demos --config $CONF --send $RECIPIENT_NUMBER "$MESSAGE" >> $LOG
   RET=$?

   if [ $RET -eq 0 ]; then
     echo -e "$HORA - Attempt $COUNT executed successfully!" >> $LOG 
     exit 0
   else
     echo -e "$HORA - Attempt $COUNT failed!" >> $LOG 
     echo -e "$HORA - Waiting 5 seconds before retry ..." >> $LOG
     sleep 5
     (( COUNT++ ))
   fi

done
