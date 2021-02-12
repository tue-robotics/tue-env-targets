#! /usr/bin/env bash

if [ ! -f /etc/apt/sources.list.d/ros-latest.list ]
then
    tue-install-debug "Adding ROS sources to apt-get"
    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

    sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

    tue-install-apt-get-update
    tue-install-debug "Added ROS sources to apt-get successfully"
else
    tue-install-debug "ROS sources already added to apt-get"
fi

# TEMP fix for to only update the key
if ! apt-key adv --list-public-keys 2>/dev/null | grep -q AB17C654
then
    sudo apt-key del 421C365BD9FF1F717815A3895523BAEEB01FA116
    sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
fi
