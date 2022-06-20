#! /usr/bin/env bash

# Check if robotnik libraries have not been installed yet
if [ ! -d "/opt/ros/${CUCR_ROS_DISTRO}/lib/robotnik_twist2ackermann" ]
then
	echo "Installing robotnik libraries"
	sudo apt install "ros-${CUCR_ROS_DISTRO}-nav-msgs" "ros-${CUCR_ROS_DISTRO}-controller-interface" "ros-${CUCR_ROS_DISTRO}-tf" "ros-${CUCR_ROS_DISTRO}-urdf" "ros-${CUCR_ROS_DISTRO}-ackermann-msgs" "ros-${CUCR_ROS_DISTRO}-sensor-msgs"
	sudo dpkg -i "${CUCR_ENV_DIR}"/repos/github.com/RobotnikAutomation/rbvogui_common/libraries/*

else
  echo "Requirements already met. Robotnik Libraries installed"
fi
