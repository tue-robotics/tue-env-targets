#! /usr/bin/env bash

pycharm="pycharm"
if dpkg-query -W -f='${Status}' $pycharm 2>/dev/null | grep -q "ok installed"
then
    tue-install-debug "Pycharm was installed  by apt, removing it now"
    tue-install-warning "Pycharm is now installed via SNAP. To remove the old apt version: sudo apt-get remove $pycharm"
else
    tue-install-debug "Pycharm was not installed by apt"
fi

# Shortcut
tue-install-cp pycharm_pycharm.desktop ~/.local/share/applications/pycharm_pycharm.desktop
