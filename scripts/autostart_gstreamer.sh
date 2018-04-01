#!/bin/bash

set -e
set -x

TITLE=gstreamer
GSTREAMER_HOME=$HOME/companion
SCRIPT=$GSTREAMER_HOME/scripts/start_gstreamer.sh
SCREEN_LOG=$GSTREAMER_HOME/logs/screen_gstreamer.log
LOG=$GSTREAMER_HOME/logs/gstreamer.log

# autostart for mavproxy
(
set -e
set -x

echo

date

cd $GSTREAMER_HOME
screen -dm -S "$TITLE" -s /bin/bash $SCRIPT
echo >> $LOG && date >> $LOG
screen -S "$TITLE" -X logfile $LOG
screen -S "$TITLE" -X log
) >> $SCREEN_LOG 2>&1
exit 0
