#! /usr/bin/env bash

# Added on 2021-08-02; Should be removed not later than 2021-11-02
ppa_file=/etc/apt/sources.list.d/catkin-tools-ubuntu-ppa-focal.list
if [ -f $ppa_file ]
then
    tue-install-info "Deleting temp catkin PPA. ROS PPA will be used instead"
    sudo rm $ppa_file
    tue-install-apt-get-update
else
    tue-install-debug "Temp catkin PPA is already deleted/has never been installed"
fi
