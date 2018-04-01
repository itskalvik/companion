#!/bin/bash

set -e
set -x

TITLE=mavproxy
MAVPROXY_HOME=$HOME/companion
SCRIPT=$MAVPROXY_HOME/scripts/start_mavproxy_telem_splitter.sh
LOG=$MAVPROXY_HOME/logs/autostart_mavproxy.log

# autostart for mavproxy
(
set -e
set -x
    
echo

date

cd $MAVPROXY_HOME
screen -L -dm -S "$TITLE" -s /bin/bash $SCRIPT
) >>$LOG 2>&1
exit 0
