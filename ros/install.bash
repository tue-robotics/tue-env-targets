#! /usr/bin/env bash
# shellcheck disable=SC1090

if [ -z "$TUE_ROS_DISTRO" ]
then
    tue-install-error "TUE_ROS_DISTRO was not set"
    return 1
fi

if [ ! -d /opt/ros/"$TUE_ROS_DISTRO" ]
then

    tue-install-system-now lsb wget

    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

    sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

    sudo apt-get update -qq

    # Install basic ROS packages.
    tue-install-system-now ros-"$TUE_ROS_DISTRO"-ros build-essential python-catkin-tools

    sudo rosdep init || true # make sure it always succeeds, even if rosdep init was already called
fi

# TEMP fix for to only update the key
if [ -z "$(apt-key list | grep 4096R/AB17C654)" ]
then
    sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
    sudo apt-key del 421C365BD9FF1F717815A3895523BAEEB01FA116
fi

if [ ! -f /tmp/rosdep_update ]
then
    tue-install-debug "Updating rosdep"
    rosdep update
    touch /tmp/rosdep_update
fi

source /opt/ros/"$TUE_ROS_DISTRO"/setup.bash

# shellcheck disable=SC2034,SC2153
TUE_SYSTEM_DIR="$TUE_ENV_DIR"/system
TUE_DEV_DIR="$TUE_ENV_DIR"/dev

if [ ! -f "$TUE_SYSTEM_DIR"/devel/setup.bash ]
then
    mkdir -p "$TUE_SYSTEM_DIR"/src
    hash g++ 2> /dev/null || tue-install-system-now g++
    # shellcheck disable=SC2164
    cd "$TUE_SYSTEM_DIR"
    catkin init
    mkdir -p src
    catkin build
    source "$TUE_SYSTEM_DIR"/devel/setup.bash
fi

if [ ! -f "$TUE_DEV_DIR"/devel/setup.bash ]
then
    mkdir -p "$TUE_DEV_DIR"/src
    hash g++ 2> /dev/null || tue-install-system-now g++
    # shellcheck disable=SC2164
    cd "$TUE_DEV_DIR"
    catkin init
    mkdir -p src
    catkin build
    source "$TUE_DEV_DIR"/devel/setup.bash
fi
