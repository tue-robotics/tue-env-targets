#! /usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [[ -f /etc/apt/sources.list.d/ros2.list ]]
then
    tue-install-echo "Removing the old ROS2 apt sources"
    tue-install-pipe sudo rm -f /etc/apt/sources.list.d/ros2.list* || tue-install-error "Failed to remove old ROS2 apt sources"
else
    tue-install-debug "Old ROS2 apt sources do not exist"
fi

# Check whether universe is enabled
ubuntu_name=$(lsb_release -cs)
ubuntu_version=$(lsb_release -rs)
needs_enabling_universe=true
# Check whether on ubuntu >= 24.04
if dpkg --compare-versions "${ubuntu_version}" ge "24.04"
then
    if ! "${SCRIPT_DIR}"/read_sources_files.py /etc/apt/sources.list.d/ubuntu.sources | jq -e 'all(.[]; .Components | index("universe") != null)' &>/dev/null
    then
        tue-install-debug "Not all sources have the universe repository enabled yet, going to enabled it"
    else
        tue-install-debug "All sources have the universe repository enabled"
        needs_enabling_universe=false
    fi
else
    if ! grep -h ^deb /etc/apt/sources.list 2>/dev/null | grep -P "${ubuntu_name}[a-z\-]* (?:[a-z ]*(?:[a-z]+(?: [a-z]+)*) )?universe" -q
    then
        tue-install-debug "No universe found in the sources.list, going to enable the universe repository"
    else
        tue-install-debug "Universe found in the sources.list, no need to enable it"
        needs_enabling_universe=false
    fi
fi

if [[ ${needs_enabling_universe} == true ]]
then
    tue-install-echo "Enabling universe repository"
    tue-install-pipe sudo add-apt-repository universe || tue-install-error "Failed to enable universe repository"
    tue-install-apt-get-update
else
    tue-install-debug "Universe repository is already enabled"
fi

ros_apt_source_pkg_name="ros2-apt-source"

installed_version=$(dpkg -s ${ros_apt_source_pkg_name} 2>/dev/null | grep -F "Version" | awk '{print $2}')

CURL_ARGS=("-H" "Accept: application/vnd.github+json")
if [[ -n ${GITHUB_TOKEN} ]]
then
    CURL_ARGS+=("-H" "Authorization: Bearer ${GITHUB_TOKEN}")
fi
newest_version=$(curl "${CURL_ARGS[@]}" -sL https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | jq -r '.tag_name')

if [[ ${newest_version} == "null" ]]
then
    tue-install-error "Failed to get the newest version of '${ros_apt_source_pkg_name}'"
fi

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
    tue-install-pipe curl -fL -o /tmp/${ros_apt_source_pkg_name}.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${newest_version}/${ros_apt_source_pkg_name}_${newest_version}.${ubuntu_name}_all.deb" || tue-install-error "Failed to download ROS2 apt source debian"
    tue-install-dpkg /tmp/${ros_apt_source_pkg_name}.deb
    tue-install-apt-get-update
fi

