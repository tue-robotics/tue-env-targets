#! /usr/bin/env bash

keyurl="https://raw.githubusercontent.com/ros/rosdistro/master/ros.key"
keyfile=/usr/share/keyrings/ros-archive-keyring.gpg
rosrepo="ros2"

rosrepourl="http://packages.ros.org/${rosrepo}/ubuntu $(lsb_release -sc) main"
sourcefile=/etc/apt/sources.list.d/ros2.list
sourceurl="deb [signed-by=${keyfile}] ${rosrepourl}"

ADD_ROS_SOURCES=false
ADD_ROS_GPG_KEY=false
FORCE_UPDATE=false

if [[ ! -f "${sourcefile}" ]]
then
    tue-install-debug "Adding ROS2 sources to apt-get"
    ADD_ROS_SOURCES=true
    ADD_ROS_GPG_KEY=true
elif [[ $(cat "${sourcefile}") != "${sourceurl}" ]]
then
    tue-install-debug "Updating ROS2 sources to apt-get"
    ADD_ROS_SOURCES=true
    ADD_ROS_GPG_KEY=true
else
    tue-install-debug "ROS2 sources already added to apt-get"
fi

if [[ "${ADD_ROS_GPG_KEY}" == "false" ]]
then
    if [[ ! -f "${keyfile}" ]]
    then
        tue-install-debug "No existing GPG key of ROS2 repository found, adding a new one"
        ADD_ROS_GPG_KEY=true
    elif tue-install-pipe gpg --import --import-options show-only "${keyfile}" 2> /dev/null; grep -q expired <<< "${TUE_INSTALL_PIPE_STDOUT}"
    then
        tue-install-debug "Updating expired GPG key of ROS2 repository"
        ADD_ROS_GPG_KEY=true
    else
        tue-install-debug "Not updating the existing GPG of the ROS2 repository"
    fi
fi

if [[ "${ADD_ROS_GPG_KEY}" == "true" ]]
then
    tue-install-pipe sudo curl -sSL "${keyurl}" -o "${keyfile}"
    tue-install-debug "Successfully added/updated ROS2 repository GPG key"

    FORCE_UPDATE=true
fi

if [[ "${ADD_ROS_SOURCES}" == "true" ]]
then
    echo "${sourceurl}" | sudo tee "${sourcefile}" > /dev/null
    tue-install-debug "Successfully added/updated ROS2 source file in apt"

    FORCE_UPDATE=true
fi

if [[ "${FORCE_UPDATE}" == "true" ]]
then
    tue-install-apt-get-update
    tue-install-debug "Successfully updated ROS2 sources"
fi
