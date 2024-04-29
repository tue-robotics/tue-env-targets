#! /usr/bin/env bash
# shellcheck disable=SC1090

# TODO(anyone): remove when tue-env is updated to new variable names
if [[ ! -v TUE_ENV_ROS_DISTRO && -v TUE_ROS_DISTRO ]]
then
    TUE_ENV_ROS_DISTRO=${TUE_ROS_DISTRO}
    tue-install-warning "Change the config of your environment to use 'TUE_ENV_ROS_DISTRO' instead of 'TUE_ROS_DISTRO'"
fi
if [[ -z "${TUE_ENV_ROS_DISTRO}" ]]
then
    tue-install-error "TUE_ENV_ROS_DISTRO was not set"
    return 1
fi

# Install basic ROS packages.
tue-install-system-now ros-"${TUE_ENV_ROS_DISTRO}"-ros

if [ ! -d /etc/ros/rosdep ]
then
    sudo rosdep init || true # make sure it always succeeds, even if rosdep init was already called
fi

rosdep_update_file="/tmp/tue_rosdep_update_${USER}"
if [ ! -f "$rosdep_update_file" ]
then
    tue-install-debug "Updating rosdep"
    tue-install-pipe rosdep update --rosdistro "${TUE_ENV_ROS_DISTRO}"
    touch "$rosdep_update_file"
fi

# TODO(anyone): remove when tue-env is updated to new variable names
[[ -v TUE_ENV_WS_DIR || ! -v TUE_WS_DIR ]] || TUE_ENV_WS_DIR=${TUE_WS_DIR}

mkdir -p "${TUE_ENV_WS_DIR}"

if [[ ! -f "${TUE_ENV_WS_DIR}"/devel/setup.bash ]]
then
    [[ -z "${TUE_ENV_ROS_VERSION}" ]] && { tue-install-warning "tue-env variable TUE_ENV_ROS_VERSION is not set. This will not be allowed in the future.\nSetting TUE_ENV_ROS_VERSION=1 temporarily."; }
    [[ "$CI" == "true" ]] && status_args=" --no-status"
    # shellcheck disable=SC2086
    TUE_ENV_ROS_VERSION=1 tue-make${status_args} || tue-install-error "Error in building the system workspace"
fi
