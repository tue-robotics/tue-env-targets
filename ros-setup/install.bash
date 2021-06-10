#! /usr/bin/env bash

keyurl="https://raw.githubusercontent.com/ros/rosdistro/master/ros.key"
keyfile=/usr/share/keyrings/ros-archive-keyring.gpg

rosrepourl="http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main"
sourcefile=/etc/apt/sources.list.d/ros-latest.list
sourceurl="deb [signed-by=${keyfile}] ${rosrepourl}"

ADD_ROS_SOURCES=false
ADD_ROS_GPG_KEY=false
FORCE_UPDATE=false

if [[ ! -f "${sourcefile}" ]]
then
    tue-install-debug "Adding ROS sources to apt-get"
    ADD_ROS_SOURCES=true
    ADD_ROS_GPG_KEY=true
elif [[ $(cat "${sourcefile}") != "${sourceurl}" ]]
then
    tue-install-debug "Updating ROS sources to apt-get"
    ADD_ROS_SOURCES=true
    ADD_ROS_GPG_KEY=true
else
    tue-install-debug "ROS sources already added to apt-get"
fi

if [[ "${ADD_ROS_GPG_KEY}" == "false" ]]
then
    if [[ ! -f "${keyfile}" ]]
    then
        tue-install-debug "No existing GPG key of ROS repository found, adding a new one"
        ADD_ROS_GPG_KEY=true
    elif gpg --import --import-options show-only "${keyfile}" 2> /dev/null | grep -q expired
    then
        tue-install-debug "Updating expired GPG key of ROS repository"
        ADD_ROS_GPG_KEY=true
    else
        tue-install-debug "Not updating the existing GPG of the ROS repository"
    fi
fi

if [[ "${ADD_ROS_GPG_KEY}" == "true" ]]
then
    sudo curl -sSL "${keyurl}" -o "${keyfile}"
    tue-install-debug "Successfully added/updated ROS repository GPG key"

    FORCE_UPDATE=true
fi

if [[ "${ADD_ROS_SOURCES}" == "true" ]]
then
    echo "${sourceurl}" | sudo tee "${sourcefile}" > /dev/null
    tue-install-debug "Successfully added/updated ROS source file in apt"

    FORCE_UPDATE=true
fi

if [[ "${FORCE_UPDATE}" == "true" ]]
then
    sudo apt-get update -qq
    tue-install-debug "Successfully updated ROS sources"
fi
