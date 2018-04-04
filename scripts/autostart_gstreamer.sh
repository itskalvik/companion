#!/bin/bash

#exit if something fails and echo every command
set -e
set -x

#Variables with file locations
TITLE=gstreamer
GSTREAMER_HOME=$HOME/companion
SCRIPT=$GSTREAMER_HOME/scripts/start_gstreamer.sh
SCREEN_LOG=$GSTREAMER_HOME/logs/screen_gstreamer.log
LOG=$GSTREAMER_HOME/logs/gstreamer.log

# autostart for gstreamer
(
set -e
set -x

#add empty line in gstreamer log file if the file already exists
if [ -s $SCREEN_LOG ]
then 
	echo
fi
#add date to gstreamer log file
date

#go to compaion repo's root and start screen with gstreamer
cd $GSTREAMER_HOME
screen -dm -S "$TITLE" -s /bin/bash $SCRIPT

#add empty line in gstreamer's log file if the file already exists
if [ -s $LOG ]
then 
	echo >> $LOG
fi
#add date to gstreamer's log file
date >> $LOG

#set log file name for screen and enable logging to file
screen -S "$TITLE" -X logfile $LOG
screen -S "$TITLE" -X log

) >> $SCREEN_LOG 2>&1 #pipe this script's output to gstreamer's screen log file
exit 0
