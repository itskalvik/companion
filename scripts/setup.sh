#!/bin/bash

set -e
set -x

#Make sure script was run with root user privileges
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
if [ ! -d $HOME/companion/logs ];then
	mkdir $HOME/companion/logs
fi


if [ "$1" != "update" ]; then
	#Remove liberoffice 
	sudo apt-get purge libreoffice-* -y
fi

#update and upgrade
sudo apt-get update
sudo apt-get upgrade -y 

if [ "$1" != "update" ]; then
	#add universe repo
	sudo apt-get install software-properties-common -y
	sudo apt-add-repository universe -y
	sudo apt-get update

	#install required packages
	sudo apt-get install -y git screen openssh-server nano
	sudo apt-get install -y python-dev python-opencv python-pip python-libxml2  python-wxgtk3.0 python-matplotlib python-pygame
	sudo apt-get install -y python-setuptools python-dev build-essential
	sudo apt-get install -y libxml2-dev libxslt1-dev
	sudo apt-get install -y gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly
	sudo -H pip install pip -U
	sudo -H pip install future
	sudo -H pip install pyserial -U

	#remove modemmanager interferes with serial devices
	sudo apt-get purge modemmanager -y
	sudo adduser $USER dialout

	#update environment variables
	echo "export PATH=$PATH:$HOME/.local/bin" >> ~/.bashrc
	echo "export PATH=$PATH:$HOME/companion/scripts" >> ~/.bashrc
	echo "export PATH=$PATH:$HOME/companion/tools" >> ~/.bashrc
	source ~/.bashrc
fi

#install mavlink
get_repo "$HOME/mavlink" "https://github.com/mavlink/mavlink.git"
pushd mavlink
git submodule init && git submodule update --recursive
pushd pymavlink
sudo python setup.py build install
popd
popd

#install mavproxy
get_repo "$HOME/mavproxy" "https://github.com/ArduPilot/MAVProxy.git"
pushd mavproxy
sudo python setup.py build install
popd

if [ "$1" != "update" ]; then
	#update rc.local to start scripts on boot
	S0="sleep 10"
	S1="sudo -H -u nvidia /bin/bash -c '/home/nvidia/companion/scripts/autostart_mavproxy.sh'"
	S2="sudo -H -u nvidia /bin/bash -c '/home/nvidia/companion/scripts/autostart_gstreamer.sh'"
	
	perl -pe "s%^exit 0%$S0\\n\\nexit 0%" -i /etc/rc.local
	perl -pe "s%^exit 0%$S1\\n\\nexit 0%" -i /etc/rc.local
	perl -pe "s%^exit 0%$S2\\n\\nexit 0%" -i /etc/rc.local
	
	#create symbolic link for pixhawk in /dev
	sudo sh -c "echo 'SUBSYSTEM==\"tty\", ATTRS{idVendor}==\"26ac\", ATTRS{idProduct}==\"0011\", SYMLINK+=\"pixhawk\"' > /etc/udev/rules.d/99-usb-serial.rules"
	sudo udevadm trigger

	#setup static ip address 192.168.2.2
	sudo echo "" >> /etc/network/interfaces
	sudo echo "## ROV direct connection" >> /etc/network/interfaces
	sudo echo "auto eth0" >> /etc/network/interfaces
	sudo echo "iface eth0 inet static" >> /etc/network/interfaces
	sudo echo "    address 192.168.2.2" >> /etc/network/interfaces
	sudo echo "    netmask 255.255.255.0" >> /etc/network/interfaces

	#install ros
	sudo $HOME/companion/scripts/install_ros.sh
fi

sudo apt-get autoremove -y
sudo apt-get autoclean -y
