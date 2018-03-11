#!/bin/bash

cd /home/nvidia

sudo apt-get purge libreoffice-*

sudo apt-get update
sudo apt-get upgrade -y 

sudo apt-get install software-properties-common -y
sudo apt-add-repository universe -y
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
sudo python setup.py build install --user
popd

sudo apt-get install -y screen

sudo sed -i -e '$i \sleep 10\n' /etc/rc.local
sudo sed -i -e '$i \sudo -H -u nvidia /bin/bash -c '~/companion/autostart_mavproxy.sh'\n' /etc/rc.local

sudo apt-get autoremove -y
sudo apt-get autoclean -y

git clone https://github.com/kdkalvik/companion.git /home/nvidia/companion
