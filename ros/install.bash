#! /usr/bin/env bash
# shellcheck disable=SC1090

if [ -z "$TUE_ROS_DISTRO" ]
then
    tue-install-error "TUE_ROS_DISTRO was not set"
    return 1
fi

# Install basic ROS packages.
tue-install-system-now ros-"$TUE_ROS_DISTRO"-ros

if [ ! -d /etc/ros/rosdep ]
then
    sudo rosdep init || true # make sure it always succeeds, even if rosdep init was already called
fi

rosdep_update_file="/tmp/tue_rosdep_update_${USER}"
if [ ! -f "$rosdep_update_file" ]
then
    tue-install-debug "Updating rosdep"
    tue-install-pipe rosdep update --rosdistro "$TUE_ROS_DISTRO"
    touch "$rosdep_update_file"
fi

mkdir -p "$TUE_SYSTEM_DIR" "$TUE_DEV_DIR"

if [ ! -f "$TUE_SYSTEM_DIR"/devel/setup.bash ]
then
    tue-make || tue-install-error "Error in building the system workspace"
fi

if [ ! -f "$TUE_DEV_DIR"/devel/setup.bash ]
then
    tue-make-dev || tue-install-error "Error in building the dev workspace"
fi
