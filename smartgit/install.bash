#! /usr/bin/env bash

if [ ! -f /etc/apt/sources.list.d/eugenesan-ubuntu-ppa-focal.list ]
then
    tue-install-echo "Adding Smartgit sources to apt-get"
    sudo add-apt-repository ppa:eugenesan/ppa
    tue-install-apt-get-update
    tue-install-debug "Added Smartgit sources to apt-get successfully"
else
    tue-install-debug "Smartgit sources already added to apt-get"
fi

tue-install-system smartgit
