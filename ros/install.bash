#! /usr/bin/env bash
# shellcheck disable=SC1090

if [ -z "$TUE_ROS_DISTRO" ]
then
    tue-install-error "TUE_ROS_DISTRO was not set"
    return 1
fi

if [ ! -d /opt/ros/"$TUE_ROS_DISTRO" ]
then
    # Install basic ROS packages.
    tue-install-system-now ros-"$TUE_ROS_DISTRO"-ros

    sudo rosdep init || true # make sure it always succeeds, even if rosdep init was already called
fi

if [ ! -f /tmp/rosdep_update ]
then
    tue-install-debug "Updating rosdep"
    rosdep update
    touch /tmp/rosdep_update
fi

source /opt/ros/"$TUE_ROS_DISTRO"/setup.bash

if [ ! -f "$TUE_SYSTEM_DIR"/devel/setup.bash ]
then
    mkdir -p "$TUE_SYSTEM_DIR"
    hash g++ 2> /dev/null || tue-install-system-now g++
    tue-make || tue-install-error "Error in building the system workspace"
    source "$TUE_SYSTEM_DIR"/devel/setup.bash
fi

if [ ! -f "$TUE_DEV_DIR"/devel/setup.bash ]
then
    mkdir -p "$TUE_DEV_DIR"
    hash g++ 2> /dev/null || tue-install-system-now g++
    tue-make-dev || tue-install-error "Error in building the dev workspace"
    source "$TUE_DEV_DIR"/devel/setup.bash
fi
