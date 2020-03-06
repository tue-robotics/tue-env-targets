#! /usr/bin/env bash
# shellcheck disable=SC2154

_skip_in_ci || return 0

### Make sure remote launching works ###
tue-install-cp ros-bash-and-run.sh ~/.ros-bash-and-run.sh
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
