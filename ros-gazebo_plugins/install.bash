#! /usr/bin/env bash

if [ "$TUE_ROS_DISTRO" != "melodic" ] && [ -L "$TUE_SYSTEM_DIR"/src/gazebo_plugins ]
then
    tue-install-info "Removing gazebo_plugins from workspace, using apt version again"
    rm "$TUE_SYSTEM_DIR"/src/gazebo_plugins
    catkin clean --workspace "$TUE_SYSTEM_DIR" --orphans
fi
