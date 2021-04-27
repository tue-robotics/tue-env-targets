#! /usr/bin/env bash

if [ ! -f /etc/apt/sources.list.d/dropbox.list ]
then
    tue-install-echo "Adding Dropbox sources to apt-get"
    sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
    sudo sh -c 'echo "deb http://linux.dropbox.com/ubuntu/ trusty main" >> /etc/apt/sources.list.d/dropbox.list'
    tue-install-apt-get-update
    tue-install-debug "Added Dropbox sources to apt-get succesfully"
else
    tue-install-debug "Dropbox sources already added to apt-get"
fi

tue-install-system dropbox
