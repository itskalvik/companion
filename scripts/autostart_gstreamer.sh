#!/bin/bash

set -e
set -x

TITLE=gstreamer
GSTREAMER_HOME=$HOME/companion
SCRIPT=$GSTREAMER_HOME/scripts/start_gstreamer.sh
LOG=$GSTREAMER_HOME/logs/autostart_gstreamer.log

# autostart for mavproxy
(
set -e
set -x

echo

date

cd $GSTREAMER_HOME
screen -L -dm -S "$TITLE" -s /bin/bash $SCRIPT
) >> $LOG 2>&1
exit 0
