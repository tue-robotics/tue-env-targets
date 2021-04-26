#! /usr/bin/env bash

if [ ! -f /etc/apt/sources.list.d/google-chrome.list ]
then
    tue-install-echo "Adding Chrome sources to apt-get"
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    tue-install-apt-get-update
    tue-install-debug "Added Chrome sources to apt-get succesfully"
else
    tue-install-debug "Chrome sources already added to apt-get"
fi

tue-install-system google-chrome-unstable
