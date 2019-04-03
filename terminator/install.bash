#! /usr/bin/env bash

if [ ! -d ~/.config/terminator ]
then
    tue-install-debug "creating $HOME/.config/terminator, because not existing yet"
    mkdir -p "$HOME"/.config/terminator
else
    tue-install-debug "$HOME/.config/terminator already exists"
fi

if [ -f ~/.config/terminator/config ]
then
    tue-install-debug "tue-install-cp config $HOME/.config/terminator/config2"
    tue-install-cp config "$HOME"/.config/terminator/config2
else
    tue-install-debug "tue-install-cp config $HOME/.config/terminator/config"
    tue-install-cp config "$HOME"/.config/terminator/config
fi
