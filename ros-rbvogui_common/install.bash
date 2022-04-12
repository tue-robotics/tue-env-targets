#! /usr/bin/env bash

# Check if robotnik libraries have not been installed yet
if [ ! -d "/opt/ros/${IROHMS_ROS_DISTRO}/lib/robotnik_twist2ackermann" ]
then
	echo "Installing robotnik libraries"
	sudo apt install "ros-${IROHMS_ROS_DISTRO}-nav-msgs" "ros-${IROHMS_ROS_DISTRO}-controller-interface" "ros-${IROHMS_ROS_DISTRO}-tf" "ros-${IROHMS_ROS_DISTRO}-urdf" "ros-${IROHMS_ROS_DISTRO}-ackermann-msgs" "ros-${IROHMS_ROS_DISTRO}-sensor-msgs"
	sudo dpkg -i "${IROHMS_ENV_DIR}"/repos/github.com/RobotnikAutomation/rbvogui_common/libraries/*

else
  echo "Requirements already met. Robotnik Libraries installed"
fi
