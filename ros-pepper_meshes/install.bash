#!/bin/bash
bold=$(tput bold)
normal=$(tput sgr0)
DIR="/home/sasm/ros/${ROS_DISTRO}/system/src/pepper_meshes/meshes"
if [ -d "$DIR" ]; then
   echo "${bold}pepper_meshes: ${normal}meshes files already installed with license."
else
   if [ "$ROS_DISTRO" = "noetic" ]; then
        echo "${bold}pepper_meshes: ${normal}'$DIR' not found, installing pepper meshes files with license. Click 'next' and follow the Setup Wizard."
        git clone https://github.com/ros-naoqi/pepper_meshes_installer.git ~/pepper_meshes_temp
        ~/pepper_meshes_temp/peppermeshes-0.2.0-linux-x64-installer.run
        rm -rf ~/pepper_meshes_temp
        cp -rf ~/.ros/pepper_meshes/meshes ~/ros/noetic/system/src/pepper_meshes
    fi
fi
    
