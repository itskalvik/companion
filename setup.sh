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

sudo sed -i -e "$i \sleep 10\nsudo -H -u nvidia /bin/bash -c '~/companion/autostart_mavproxy.sh'" rc.local

git clone https://github.com/kdkalvik/companion.git /home/nvidia/companion



<<<<<<< HEAD

=======
sudo chmod +x /etc/init.d/mavproxy
sudo chown root:root /etc/init.d/mavproxy
sudo update-rc.d mavproxy defaults
>>>>>>> d0fe087cd8528d7314a7e15ee51594aa13c8ebca
