#! /usr/bin/env bash

if [ ! -d ~/.config/terminator ]
then
    # shellcheck disable=SC2088
    irohms-install-debug "creating ~/.config/terminator, because not existing yet"
    mkdir -p ~/.config/terminator
else
    # shellcheck disable=SC2088
    irohms-install-debug "~/.config/terminator already exists"
fi

if [ -f ~/.config/terminator/config ]
then
    # shellcheck disable=SC2088
    irohms-install-debug "irohms-install-cp config ~/.config/terminator/config2"
    irohms-install-cp config ~/.config/terminator/config2
else
    # shellcheck disable=SC2088
    irohms-install-debug "irohms-install-cp config ~/.config/terminator/config"
    irohms-install-cp config ~/.config/terminator/config
fi
