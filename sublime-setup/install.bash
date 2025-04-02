#! /usr/bin/env bash

arch="$(dpkg-architecture -q DEB_HOST_ARCH)"

key_file="/etc/apt/trusted.gpg.d/sublimehq-archive.gpg"
key_folder=$(dirname ${key_file})
key_fingerprint="28A8F901A"
key_needs_to_be_added="false"
key_url="https://download.sublimetext.com/sublimehq-pub.gpg"

source_file="/etc/apt/sources.list.d/sublime-text.list"
source_needs_to_be_added="false"
source_url="deb [arch=${arch} signed-by=${key_file}] https://download.sublimetext.com/ apt/stable/"

if [[ -z "${arch}" ]]
then
    tue-install-warning "Could not retrieve the system architecture, so not installing package."
else
    # Add stable sublime repository source
    if [[ ! -f "${key_file}" ]]
    then
        tue-install-debug "Keyring '${key_file}' doesn't exist yet."
        key_needs_to_be_added=true
    elif ! gpg --show-keys "${key_file}" | grep -q "${key_fingerprint}" &> /dev/null
    then
        tue-install-debug "Keyring '${key_file}' doesn't match the fingerprint '${key_fingerprint}'."
        key_needs_to_be_added=true
    fi

    if [[ "${key_needs_to_be_added}" == "true" ]]
    then
        tue-install-debug "Make sure '${key_folder}' folder exists with the correct permissions."
        tue-install-pipe sudo install -m 0755 -d "${key_folder}"
        tue-install-debug "Downloading gpg key of sublime repo with fingerprint '${key_fingerprint}'."
        curl -fsSL ${key_url} | sudo gpg --dearmor --yes -o "${key_file}"
    else
        tue-install-debug "GPG key of sublime repo with fingerprint '${key_fingerprint}' already exists, so not installing it."
    fi

    if [[ ! -f "${source_file}" ]]
    then
        tue-install-debug "Adding Sublime sources to apt-get"
        source_needs_to_be_added=true
    elif [[ $(cat "${source_file}") != "${source_url}" ]]
    then
        tue-install-debug "Updating Sublime sources to apt-get"
        source_needs_to_be_added=true
    else
        tue-install-debug "Sublime sources already added to apt-get"
    fi

    if [[ "${source_needs_to_be_added}" == "true" ]]
    then
        echo "${source_url}" | sudo tee ${source_file} > /dev/null
        tue-install-apt-get-update
    fi
fi
