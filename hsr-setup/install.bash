#! /usr/bin/env bash

if [ ! -f "/etc/apt/sources.list.d/tmc.list" ]
then
    if [ ! -f "/etc/apt/auth.conf.d/tmc.conf" ]
    then
        tue-install-debug "Adding HSR repository login credentials to apt-get"
        sudo sh -c 'echo "machine packages.hsr.io login hsr-user password jD3k4G2e" > /etc/apt/auth.conf.d/tmc.conf'
        tue-install-debug "Added HSR repository login credentials to apt-get succesfully"
    else
        tue-install-debug "HSR repository login credentials already added to apt-get"
    fi

    tue-install-debug "Adding HSR sources to apt-get"
    sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
    sudo sh -c 'echo "deb https://packages.hsr.io/ros/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/tmc.list'
    sudo sh -c 'echo "deb https://packages.hsr.io/tmc/ubuntu `lsb_release -cs` multiverse main" >> /etc/apt/sources.list.d/tmc.list'

    wget https://hsr-user:jD3k4G2e@packages.hsr.io/tmc.key -O - | sudo apt-key add -
    wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -

    sudo apt-get update -qq
    tue-install-debug "Added HSR sources to apt-get succesfully"
else
    tue-install-debug "HSR sources already added to apt-get"
fi
