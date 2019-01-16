#! /usr/bin/env bash

script_dir=$(dirname "${BASH_SOURCE[0]}")
source /etc/lsb-release

if [[ $DISTRIB_CODENAME = trusty ]]
then

    if [[ ! -f /etc/apt/sources.list.d/webupd8team-sublime-text-3-$DISTRIB_CODENAME.list ]]
    then
        sudo add-apt-repository ppa:webupd8team/sublime-text-3
        sudo apt-get update
        $script_dir/sublime-package-control.py
    fi

elif [[ $DISTRIB_CODENAME = xenial ]]
then

    if [[ ! -f /etc/apt/sources.list.d/webupd8team-ubuntu-sublime-text-3-$DISTRIB_CODENAME.list ]]
    then
        sudo add-apt-repository ppa:webupd8team/sublime-text-3
        sudo apt-get update
        $script_dir/sublime-package-control.py
    fi

else
    echo "Error: unknown distribution: $DISTRIB_CODENAME"
fi

tue-install-system sublime-text-installer
