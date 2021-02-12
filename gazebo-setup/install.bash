#! /usr/bin/env bash

if [ ! -f /etc/apt/sources.list.d/gazebo-stable.list ]
then
    tue-install-debug "Adding Gazebo sources to apt-get"
    sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'

    wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -

    tue-install-apt-get-update
    tue-install-debug "Added Gazebo sources to apt-get successfully"
else
    tue-install-debug "Gazebo sources already added to apt-get"
fi
