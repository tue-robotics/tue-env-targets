#! /usr/bin/env bash
# shellcheck disable=SC1090

if [ -z "$TUE_ROS_DISTRO" ]
then
    tue-install-error "TUE_ROS_DISTRO was not set"
    return 1
fi

# Install basic ROS packages.
tue-install-system-now ros-"$TUE_ROS_DISTRO"-ros build-essential # build-essential needed right now

if [ ! -d /etc/ros/rosdep ]
then
    sudo rosdep init || true # make sure it always succeeds, even if rosdep init was already called
fi

rosdep_update_file="/tmp/rosdep_update_${USER}"
if [ ! -f "$rosdep_update_file" ]
then
    tue-install-debug "Updating rosdep"
    rosdep update
    touch "$rosdep_update_file"
fi
