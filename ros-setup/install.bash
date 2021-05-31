#! /usr/bin/env bash

if [ ! -f /etc/apt/sources.list.d/ros-latest.list ]
then
    tue-install-echo "Adding ROS sources to apt-get"
    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

    tue-install-pipe sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

    tue-install-apt-get-update
    tue-install-debug "Added ROS sources to apt-get successfully"
else
    tue-install-debug "ROS sources already added to apt-get"
fi

# Check for expired key and update
if apt-key adv --list-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 2>/dev/null | grep -q expired
then
    tue-install-echo "Updating expired GPG key"
    tue-install-pipe sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
fi
