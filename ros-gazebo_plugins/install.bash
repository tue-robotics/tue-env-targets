#! /usr/bin/env bash

if [ "$TUE_ROS_DISTRO" != "melodic" ] && [ -L "$TUE_SYSTEM_DIR"/src/gazebo_plugins ]
then
    tue-install-info "Removing gazebo_plugins from workspace, using apt version again"
    rm -rf "$(git -C "$(realpath "$TUE_SYSTEM_DIR"/src/gazebo_plugins)" rev-parse --show-toplevel)"
    rm "$TUE_SYSTEM_DIR"/src/gazebo_plugins
    catkin clean --workspace "$TUE_SYSTEM_DIR" --orphans
fi

desired_version="2.9.2"
installed_version=$(apt-cache policy ros-$TUE_ROS_DISTRO-gazebo-plugins | grep "Installed" | awk '{print $2}')
if [ $installed_version == "(none)" ]
then
    tue-install-debug "Not installed yet, so the newest version will be installed"
elif version_gt "$desired_version" "$installed_version"
then
    tue-install-echo "Going to install desired version($desired_version), current version: $installed_version"
    tue-install-pipe sudo apt-get install --assume-yes -q ros-$TUE_ROS_DISTRO-gazebo-plugins
else
    tue-install-debug "Already on the desired version($desired_version): $installed_version"
fi
