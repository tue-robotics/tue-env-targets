#! /usr/bin/env bash

if ! hash bower &> /dev/null
then
    # We need the nodejs package manager
    irohms-install-target nodejs

    sudo -H npm install -g bower
fi



