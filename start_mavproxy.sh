#!/bin/bash

set -e
set -x

# start mavproxy with:
#    - main connection to cmavnode via UDP
#    - udp connection on port 9000 for use by other processes
#    - udp broadcast connection to allow multiple GCSs to connect to the flight controller via mavproxy
/home/nvidia/.local/bin/mavproxy.py \
    --master=/dev/serial/by-id/usb-3D_Robotics_PX4_FMU_v2.x_0-if00,115200 \
    --load-module='GPSInput,DepthOutput' \
    --out udpbcast:192.168.1.255:14550 \
    --out udpin:localhost:9000 \
    --source-system=200 \
    --cmd="set heartbeat 0"





