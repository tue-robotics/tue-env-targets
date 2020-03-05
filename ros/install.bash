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

if [ ! -f /tmp/rosdep_update ]
then
    tue-install-debug "Updating rosdep"
    rosdep update
    touch /tmp/rosdep_update
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
