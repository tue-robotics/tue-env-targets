#! /usr/bin/env bash

if [ ! -f /etc/apt/sources.list.d/sublime-text.list ]
then
    tue-install-debug "Adding Sublime sources to apt-get"
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo sh -c 'echo "deb https://download.sublimetext.com/ apt/stable/" >> /etc/apt/sources.list.d/sublime-text.list'

    tue-install-apt-get-update
    tue-install-debug "Added Sublime sources to apt-get successfully"
fi

tue-install-system sublime-text
