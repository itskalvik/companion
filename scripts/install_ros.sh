#!/bin/bash

set -e
set -x

#Make sure script was run with root user privileges
if [[ $UID != 0 ]]; then
	echo "This script require root privileges!" 1>&2
	exit 1
fi

#setup sources.list
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

#set up keys
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

#update
sudo apt-get update

#install ros base
sudo apt-get install ros-kinetic-ros-base -y

#initialize rosdep
sudo rosdep init
rosdep update

#setup environment
echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
source ~/.bashrc

#install dependencies
sudo apt-get install python-rosinstall python-rosinstall-generator python-wstool build-essential -y

#setup catkin workspace
cd $HOME
mkdir -p ~/catkin_ws/src
sudo chmod a+rw ~/catkin_ws
sudo chmod a+rw ~/catkin_ws/src
cd ~/catkin_ws/
source /opt/ros/kinetic/setup.bash
catkin_make

#setup environment
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
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
