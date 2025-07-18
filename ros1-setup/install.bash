#! /usr/bin/env bash

if [[ -f /etc/apt/sources.list.d/ros.list ]]
then
    tue-install-echo "Removing the old ROS apt sources"
    tue-install-pipe sudo rm -f /etc/apt/sources.list.d/ros.list* || tue-install-error "Failed to remove old ROS apt sources"
else
    tue-install-debug "Old ROS APT sources do not exist"
fi

ubuntu_name=$(lsb_release -cs)

# Check whether universe is enabled
if ! grep -h ^deb /etc/apt/sources.list 2>/dev/null | grep -P "${ubuntu_name}[a-z\-]* (?:[a-z ]*(?:[a-z]+(?: [a-z]+)*)) universe" -q
then
    tue-install-echo "Enabling universe repository"
    tue-install-pipe sudo add-apt-repository universe || tue-install-error "Failed to enable universe repository"
    tue-install-apt-get-update
else
    tue-install-debug "Universe repository is already enabled"
fi

ros_apt_source_pkg_name="ros-apt-source"

installed_version=$(dpkg -s ${ros_apt_source_pkg_name} 2>/dev/null | grep -F "Version" | awk '{print $2}')
newest_version=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
needs_install=true
if [[ -n ${installed_version} ]]
then
    if [[ ${installed_version} == "${newest_version}~${ubuntu_name}" ]]
    then
        tue-install-debug "The most recent version of '${ros_apt_source_pkg_name}' is already installed '${installed_version}'"
        needs_install=false
    else
        tue-install-debug "Newer version, '${newest_version}', of '${ros_apt_source_pkg_name}' available, currently installed: '${installed_version}'"
    fi
else
    tue-install-debug "No version of '${ros_apt_source_pkg_name}' installed"
fi

if [[ ${needs_install} == true ]]
then
    tue-install-debug "Going to install ${ros_apt_source_pkg_name}"
    tue-install-pipe curl -L -o /tmp/${ros_apt_source_pkg_name}.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${newest_version}/${ros_apt_source_pkg_name}_${newest_version}.${ubuntu_name}_all.deb" || tue-install-error "Failed to download ROS apt source debian"
    tue-install-dpkg /tmp/${ros_apt_source_pkg_name}.deb
    tue-install-apt-get-update
fi

