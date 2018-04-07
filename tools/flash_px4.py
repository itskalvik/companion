#!/usr/bin/python -u

import os
import time
import sys

if (len(sys.argv) != 2):
	print "Error: Need 1 argument for flash_px4.\nUsage: flash_px4.py <file path of firmware file>" 
	exit(1)
else:
	try:
		print("Attempting upload from file %s") % str(sys.argv[1])
		open(str(sys.argv[1]))
	except Exception as e:
		print("Error opening file %s: %s") % (str(sys.argv[1]), e)
		exit(1)          
                
# Stop screen session with mavproxy
print "Stopping mavproxy"
os.system("screen -X -S mavproxy quit")

# Flash Pixhawk
print "Flashing Pixhawk..."
if str(sys.argv[1]) is not None:
    if(os.system("python -u px_uploader.py --port /dev/pixhawk '%s'" % str(sys.argv[1])) != 0):
                print "Error flashing pixhawk!"
                exit(1)

# Wait a few seconds
print "Waiting to restart mavproxy..."
time.sleep(10)

# Start screen session with mavproxy
print "Restarting mavproxy"
os.system("/home/nvidia/companion/scripts/autostart_mavproxy.sh")

print "Complete!"
