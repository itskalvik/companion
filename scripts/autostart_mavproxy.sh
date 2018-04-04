#!/bin/bash

#exit if something fails and echo every command
set -e
set -x

#Variables with file locations
TITLE=mavproxy
MAVPROXY_HOME=$HOME/companion
SCRIPT=$MAVPROXY_HOME/scripts/start_mavproxy_telem_splitter.sh
SCREEN_LOG=$MAVPROXY_HOME/logs/screen_mavproxy.log
LOG=$MAVPROXY_HOME/logs/mavproxy.log

# autostart for mavproxy
(
set -e
set -x

#add empty line in mavproxy log file if the file already exists
if [ -s $SCREEN_LOG ]
then 
	echo
fi
#add date to mavproxy log file
date

#go to compaion repo's root and start screen with mavproxy
cd $MAVPROXY_HOME
screen -dm -S "$TITLE" -s /bin/bash $SCRIPT

#add empty line in mavproxy's log file if the file already exists
if [ -s $LOG ]
then 
	echo >> $LOG
fi
#add date to gstreamer's log file
date >> $LOG

#set log file name for screen and enable logging to file
screen -S "$TITLE" -X logfile $LOG
screen -S "$TITLE" -X log
) >>$SCREEN_LOG 2>&1 #pipe this script's output to mavproxy's screen log file
exit 0
