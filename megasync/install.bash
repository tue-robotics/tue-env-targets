#! /usr/bin/env bash

DATA_DIR="${HOME}/MEGA"
if [[ ! -d "${DATA_DIR}" ]]
then
    # Download mega sync
    UBUNTU_VERSION=$(lsb_release -sr)
    tue-install-debug "Ubuntu version: ${UBUNTU_VERSION}"

    LINK="https://mega.nz/linux/repo/xUbuntu_${UBUNTU_VERSION}/amd64/megasync-xUbuntu_${UBUNTU_VERSION}_amd64.deb"
    DEST="/tmp/${UBUNTU_VERSION}_MEGA_SYNC.deb"

    tue-install-debug "Downloading ${LINK} to ${DEST}"
    wget "${LINK}" -O "${DEST}"

    # Install
    tue-install-debug "Installing debian package ..."
    tue-install-dpkg "${DEST}"

    tue-install-info "NOW Please configure the mega client with the AMIGO credentials"
fi
