#!/bin/bash

#Make sure scriot was run with root user privileges
if [[ $UID != 0 ]]; then
	echo "This script require root privileges!" 1>&2
	exit 1
fi

#Function to clone repo if it doesnt exist and update repo if it exists
get_repo(){
	if [ -d $1 ]
	then
		cd $1
		git reset --hard origin/master
		git pull origin master
		cd ..
	else
		git clone $2 $1
	fi
}

#get companion repo
get_repo "$HOME/companion" "https://github.com/kdkalvik/companion.git"

sudo apt-get purge libreoffice-*

sudo apt-get update
sudo apt-get upgrade -y 

sudo apt-get install software-properties-common -y
sudo apt-add-repository universe -y
sudo apt-get update

sudo apt-get install git screen -y
sudo apt-get install -y python-dev python-opencv python-pip python-libxml2  python-wxgtk3.0 python-matplotlib python-pygame
sudo apt-get install -y python-setuptools python-dev build-essential
sudo apt-get install -y libxml2-dev libxslt1-dev
sudo apt-get install gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly
sudo pip install pip -U
sudo pip install future
sudo pip install pyserial -U

sudo apt-get purge modemmanager -y
sudo adduser $USER dialout

echo "export PATH=$PATH:$HOME/.local/bin" >> ~/.bashrc
source ~/.bashrc

get_repo "$HOME/mavlink" "https://github.com/mavlink/mavlink.git"
pushd mavlink
git submodule init && git submodule update --recursive
pushd pymavlink
sudo python setup.py build install
popd
popd

get_repo "$HOME/mavproxy" "https://github.com/ArduPilot/MAVProxy.git"
pushd mavproxy
sudo python setup.py build install
popd

sudo sed -i -e '$i \sleep 10\n' /etc/rc.local
sudo sed -i -e '$i \sudo -H -u nvidia /bin/bash -c '/home/nvidia/companion/scripts/autostart_mavproxy.sh'\n' /etc/rc.local
sudo sed -i -e '$i \sudo -H -u nvidia /bin/bash -c '/home/nvidia/companion/scripts/autostart_gstreamer.sh'\n' /etc/rc.local

sudo sh -c "echo 'SUBSYSTEM==\"tty\", ATTRS{idVendor}==\"26ac\", ATTRS{idProduct}==\"0011\", SYMLINK+=\"pixhawk\"' > /etc/udev/rules.d/99-usb-serial.rules"
sudo udevadm trigger

sudo ./install_ros.sh

sudo apt-get autoremove -y
sudo apt-get autoclean -y
