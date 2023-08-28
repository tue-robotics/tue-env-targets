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

mkdir -p "$TUE_SYSTEM_DIR"

if [ ! -f "$TUE_SYSTEM_DIR"/devel/setup.bash ]
then
    [[ -z "${TUE_ROS_VERSION}" ]] && { tue-install-warning "tue-env variable TUE_ROS_VERSION is not set. This will not be allowed in the future.\nSetting TUE_ROS_VERSION=1 temporarily."; }
    [[ "$CI" == "true" ]] && status_args=" --no-status"
    # shellcheck disable=SC2086
    TUE_ROS_VERSION=1 tue-make${status_args} || tue-install-error "Error in building the system workspace"
fi
