#!/bin/bash

#set -e
#set -x

#Make sure script is not run as root user
if [ "$UID" = "0" ];then
	echo "Root privileges are not required for running install_ros."
	exit -1
fi

#Function to update file if changes are not there
update_file(){
	grep "$1" $2
	if [ $? != 0 ];then
		echo "$1" >> $2
	fi
}

#setup sources.list
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

#set up keys
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

#update
sudo apt-get update

#install ros base
sudo apt-get install ros-kinetic-ros-base -y

#initialize rosdep
sudo rm /etc/ros/rosdep/sources.list.d/20-default.list
sudo rosdep init
rosdep update

#setup environment
update_file "source /opt/ros/kinetic/setup.bash" ~/.bashrc
source ~/.bashrc

#install dependencies
sudo apt-get install python-rosinstall python-rosinstall-generator python-wstool build-essential -y

#setup catkin workspace
cd $HOME
if [ ! -d $HOME/catkin_ws/src];then
	mkdir -p $HOME/catkin_ws/src
	cd ~/catkin_ws/
	source /opt/ros/kinetic/setup.bash
	catkin_make
fi

#setup environment
update_file "source ~/catkin_ws/devel/setup.bash" ~/.bashrc
source ~/.bashrc

#install mavros
sudo apt-get install ros-kinetic-mavros ros-kinetic-mavros-extras ros-kinetic-mavros-msgs -y

#install libgeographic
cd $HOME

sudo apt-get install libgeographic-dev -y
sudo apt-get install geographiclib-tools -y

wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh

chmod a+x install_geographiclib_datasets.sh
sudo ./install_geographiclib_datasets.sh
rm install_geographiclib_datasets.sh
