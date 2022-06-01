#!/bin/bash

if [ "$ROS_DISTRO" = "noetic" ]; then
    git clone https://github.com/ros-naoqi/pepper_meshes_installer.git ~/pepper_meshes_temp
    ~/pepper_meshes_temp/peppermeshes-0.2.0-linux-x64-installer.run
    rm -rf ~/pepper_meshes_temp
    cp -rf ~/.ros/pepper_meshes/meshes ~/ros/noetic/system/src/pepper_meshes
fi
