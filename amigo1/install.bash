#! /usr/bin/env bash

# Check if the config is the same
if ! cmp /etc/chrony/chrony.conf "$(dirname "${BASH_SOURCE[0]}")/chrony.conf" --quiet
then
    cucr-install-info "Chrony config is probably not correct, will copy"

    # Backup old config
    sudo mv /etc/chrony/chrony.conf /etc/chrony/chrony.conf.backup

    # Copy new config
    cucr-install-cp chrony.conf /etc/chrony/chrony.conf

    # Restart chrony
    sudo service chrony restart
fi

# UDEV rules
if [ ! -f /etc/udev/rules.d/0-hokuyo.rules ]
then
    cucr-install-cp udev-rules/* /etc/udev/rules.d/
fi
