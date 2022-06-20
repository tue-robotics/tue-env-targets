#! /usr/bin/env bash

if [ ! -d ~/.config/terminator ]
then
    # shellcheck disable=SC2088
    cucr-install-debug "creating ~/.config/terminator, because not existing yet"
    mkdir -p ~/.config/terminator
else
    # shellcheck disable=SC2088
    cucr-install-debug "~/.config/terminator already exists"
fi

if [ -f ~/.config/terminator/config ]
then
    # shellcheck disable=SC2088
    cucr-install-debug "cucr-install-cp config ~/.config/terminator/config2"
    cucr-install-cp config ~/.config/terminator/config2
else
    # shellcheck disable=SC2088
    cucr-install-debug "cucr-install-cp config ~/.config/terminator/config"
    cucr-install-cp config ~/.config/terminator/config
fi
