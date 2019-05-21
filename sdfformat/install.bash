#! /usr/bin/env bash

if [ ! -f /etc/apt/sources.list.d/gazebo-stable.list ]
then
    tue-install-debug "Adding Gazebo source to apt-get"
    sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'

    wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -

    sudo apt-get update -qq
    tue-install-debug "Succesfully added Gazebo source to apt-get"
else
    tue-install-debug "Gazebo source has already been added"
fi

if [ "$(lsb_release -sc)" == "xenial" ]
then
    tue-install-system libsdformat4-dev
else
    tue-install-system libsdformat6-dev
fi
