#! /usr/bin/env bash

function main
{
    if [[ -f /etc/apt/preferences.d/cuda-repository-pin-600 ]]
    then
        tue-install-debug "cuda-keyring is already installed."
        return 0
    fi
    tue-install-debug "Going to install cuda-keyring."
    local arch distro ubuntu_id ubuntu_version
    ubuntu_id=$(lsb_release -is)
    ubuntu_id="${ubuntu_id,,}"
    ubuntu_version=$(lsb_release -rs)
    ubuntu_version="${ubuntu_version//./}"
    distro=${ubuntu_id}${ubuntu_version}
    arch=$(uname -p)

    tue-install-debug "ubuntu_id: ${ubuntu_id}"
    tue-install-debug "ubuntu_version: ${ubuntu_version}"
    tue-install-debug "arch: ${arch}"

    local tmp_keyring_file
    tmp_keyring_file=/tmp/cuda-keyring.deb

    tue-install-pipe wget --no-verbose https://developer.download.nvidia.com/compute/cuda/repos/"${distro}"/"${arch}"/cuda-keyring_1.1-1_all.deb -O ${tmp_keyring_file}
    tue-install-dpkg ${tmp_keyring_file}
    
    tue-install-apt-get-update
}

main "$@"

