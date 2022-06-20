#! /usr/bin/env bash
# shellcheck disable=SC1090

if [ -z "$IROHMS_ROS_DISTRO" ]
then
    cucr-install-error "IROHMS_ROS_DISTRO was not set"
    return 1
fi

# Install basic ROS packages.
cucr-install-system-now ros-"$IROHMS_ROS_DISTRO"-ros

if [ ! -d /etc/ros/rosdep ]
then
    sudo rosdep init || true # make sure it always succeeds, even if rosdep init was already called
fi

rosdep_update_file="/tmp/rosdep_update_${USER}"
if [ ! -f "$rosdep_update_file" ]
then
    cucr-install-debug "Updating rosdep"
    rosdep update
    touch "$rosdep_update_file"
fi

mkdir -p "$IROHMS_SYSTEM_DIR" "$IROHMS_DEV_DIR"

if [ ! -f "$IROHMS_SYSTEM_DIR"/devel/setup.bash ]
then
    cucr-make || cucr-install-error "Error in building the system workspace"
fi

if [ ! -f "$IROHMS_DEV_DIR"/devel/setup.bash ]
then
    cucr-make-dev || cucr-install-error "Error in building the dev workspace"
fi
