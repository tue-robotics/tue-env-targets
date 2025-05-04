#! /usr/bin/env bash
# shellcheck disable=SC1090

if [[ -z "${TUE_ENV_ROS_DISTRO}" ]]
then
    tue-install-error "TUE_ENV_ROS_DISTRO was not set"
    return 1
fi

# Install basic ROS packages and eProsima DDS implementation.
tue-install-system-now ros-"${TUE_ENV_ROS_DISTRO}"-ros-core ros-"${TUE_ENV_ROS_DISTRO}"-rmw-fastrtps-cpp

# Setup the build environment
mkdir -p "${TUE_ENV_WS_DIR}"

if [[ ! -f "${TUE_ENV_WS_DIR}"/install/setup.bash ]]
then
    [[ -z "${TUE_ENV_ROS_VERSION}" ]] && { tue-install-warning "tue-env variable TUE_ENV_ROS_VERSION is not set. This will not be allowed in the future.\nSetting TUE_ENV_ROS_VERSION=2 temporarily."; }
    TUE_ENV_ROS_VERSION=2 tue-make || tue-install-error "Error in building the ROS2 system workspace"
fi
