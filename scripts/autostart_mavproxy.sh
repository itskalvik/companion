#!/bin/bash

set -e
set -x

TITLE=mavproxy
MAVPROXY_HOME=$HOME/companion
SCRIPT=$MAVPROXY_HOME/scripts/start_mavproxy_telem_splitter.sh
SCREEN_LOG=$MAVPROXY_HOME/logs/screen_mavproxy.log
LOG=$MAVPROXY_HOME/logs/mavproxy.log

# autostart for mavproxy
(
set -e
set -x
    
echo

date

cd $MAVPROXY_HOME
screen -dm -S "$TITLE" -s /bin/bash $SCRIPT
echo >> $LOG && date >> $LOG
screen -S "$TITLE" -X logfile $LOG
screen -S "$TITLE" -X log
) >>$SCREEN_LOG 2>&1
exit 0
