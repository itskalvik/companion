#!/bin/bash

if [ $(id -u) -ne 0 ]; then
   echo >&2 "Must be run as root"
   exit 1
fi

set -e
set -x

cd /home/nvidia

sudo apt-get update
sudo apt-get upgrade -y 
sudo apt-get autoremove -y
sudo apt-get autoclean

sudo apt-get install software-properties-common
sudo apt-add-repository universe
sudo apt-get update

sudo apt-get install git -y
sudo apt-get install -y python-dev python-pip python-libxml2  python-wxgtk3.0 python-matplotlib python-pygame
sudo apt-get install -y python-setuptools python-dev build-essential
sudo apt-get install -y libxml2-dev libxslt1-dev
sudo pip install pip -U
sudo pip install future

sudo apt-get purge modemmanager -y
sudo adduser $USER dialout

echo "export PATH=$PATH:$HOME/.local/bin" >> ~/.bashrc
source ~/.bashrc

git clone https://github.com/mavlink/mavlink.git /home/nvidia/mavlink

pushd mavlink
git submodule init && git submodule update --recursive
pushd pymavlink
sudo python setup.py build install
popd
popd

git clone https://github.com/bluerobotics/MAVProxy.git /home/nvidia/mavproxy

pushd mavproxy
python setup.py build install --user
popd

sudo apt-get install -y screen

sudo cp /etc/init.d/skeleton /etc/init.d/mavproxy

sudo sed -i '/DESC/d' /etc/init.d/mavproxy
sudo sed -i '/DAEMON/d' /etc/init.d/mavproxy

echo '''DAEMON_ARGS="--master=/dev/serial/by-id/usb-3D_Robotics_PX4_FMU_v2.x_0-if00,115200 --load-module='GPSInput,DepthOutput' --source-system=200 --cmd='set heartbeat 0' --out udpin:localhost:9000 --out udpbcast:192.168.1.6:14550 --daemon"''' >> /etc/init.d/mavproxy
echo "NAME=mavproxy.py" >> /etc/init.d/mavproxy
echo 'DESC="Mavproxy based mavlink to wifi gateway"' >> /etc/init.d/mavproxy
echo "Provides: mavgateway" >> /etc/init.d/mavproxy
echo "Short-Description: Mavlink to UDP gateway service" >> /etc/init.d/mavproxy
echo "DAEMON=/usr/local/bin/$NAME" >> /etc/init.d/mavproxy

sudo chmod +x /etc/init.d/mavproxy
sudo chown root:root /etc/init.d/mavproxy
sudo update-rc.d mavproxy defaults
