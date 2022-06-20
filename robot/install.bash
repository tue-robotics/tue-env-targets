#! /usr/bin/env bash

### Make sure remote launching works ###
cucr-install-cp ros-bash-and-run.sh ~/.ros-bash-and-run.sh
chmod +x ~/.ros-bash-and-run.sh

### Allow user to access serial interfaces ###
if ! groups "$USER" | grep -q dialout
then
    sudo gpasswd --add "$USER" dialout
fi
### Allow user to access video interfaces ###
if ! groups "$USER" | grep -q video
then
    sudo gpasswd --add "$USER" video
fi
