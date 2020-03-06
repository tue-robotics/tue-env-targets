#! /usr/bin/env bash
# shellcheck disable=SC2154

[[ "$CI" == "true" ]] && return 0

if [[ "$ROBOT_REAL" != "true" ]]
  then
    read -r -p "This package ($target) should only be installed on the robot itself, not on your own PC. Are you sure to continue? [y/N] " response
    response=${response,,}    # tolower
    if [[ "$response" =~ ^(yes|y)$ ]]
    then
      :
    else
      return 1
    fi
fi

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
