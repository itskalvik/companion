#!/usr/bin/python -u

import os
from urllib2 import urlopen
import time
import sys
import signal
from optparse import OptionParser

def timeout(signum, frame):
    print 'Timed out waiting for firmware on stdin!'
    exit(1)

parser = OptionParser()
parser.add_option("--file", dest="file", default=None, help="Load from file")
(options,args) = parser.parse_args()

try:
    print("Attempting upload from file %s") % options.file
    open(options.file)
except Exception as e:
    print("Error opening file %s: %s") % (options.file, e)
    exit(1)          
                
# Stop screen session with mavproxy
print "Stopping mavproxy"
os.system("screen -X -S mavproxy quit")

# Flash Pixhawk
print "Flashing Pixhawk..."
if options.file is not None:
    if(os.system("python -u /home/nvidia/companion/tools/px_uploader.py --port /dev/ttyACM0 '%s'" % options.file) != 0):
                print "Error flashing pixhawk!"
                exit(1)

# Wait a few seconds
print "Waiting to restart mavproxy..."
time.sleep(10)

# Start screen session with mavproxy
print "Restarting mavproxy"
os.system("screen -dm -S mavproxy /home/nvidia/companion/scripts/start_mavproxy_telem_splitter.sh")

print "Complete!"
