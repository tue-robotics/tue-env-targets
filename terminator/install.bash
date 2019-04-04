#! /usr/bin/env bash

if [ ! -d ~/.config/terminator ]
then
    # shellcheck disable=SC2088
    tue-install-debug "creating ~/.config/terminator, because not existing yet"
    mkdir -p ~/.config/terminator
else
    # shellcheck disable=SC2088
    tue-install-debug "~/.config/terminator already exists"
fi

if [ -f ~/.config/terminator/config ]
then
    # shellcheck disable=SC2088
    tue-install-debug "tue-install-cp config ~/.config/terminator/config2"
    tue-install-cp config ~/.config/terminator/config2
else
    # shellcheck disable=SC2088
    tue-install-debug "tue-install-cp config ~/.config/terminator/config"
    tue-install-cp config ~/.config/terminator/config
fi
