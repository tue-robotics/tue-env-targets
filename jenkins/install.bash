#! /usr/bin/env bash

if [ ! -f "/etc/apt/sources.list.d/jenkins.list" ]
then
    tue-install-echo "Adding Jenkins sources to apt-get"
    wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
    tue-install-apt-get-update
    tue-install-debug "Added Jenkins sources to apt-get succesfully"
else
    tue-install-debug "Jenkins sources already added to apt-get"
fi

tue-install-system jenkins
