#! /usr/bin/env bash

# Check if robotnik libraries have not been installed yet
if [ ! -d "/opt/ros/${IROHMS_ROS_DISTRO}/lib/robotnik_twist2ackermann" ]
then
	echo "Installing robotnik libraries"
	sudo apt install "ros-${IROHMS_ROS_DISTRO}-nav-msgs" "ros-${IROHMS_ROS_DISTRO}-controller-interface"
	sudo dpkg -i "$(dirname "${IROHMS_ENV_TARGETS_DIR}")"/../../melodic/repos/github.com/RobotnikAutomation/rbvogui_common/libraries/*
fi
