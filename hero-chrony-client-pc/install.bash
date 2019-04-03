#! /usr/bin/env bash
set -e

tue-install-system-now chrony

# Check config file
if ! cmp /etc/chrony/chrony.conf "$(dirname "${BASH_SOURCE[0]}")"/chrony.conf --quiet
then
    echo "Chrony config is probably not correct, will copy"

    # Copy and backup old config
    sudo install --backup=numbered --compare --verbose "$(dirname "${BASH_SOURCE[0]}")"/chrony.conf /etc/chrony/chrony.conf

    # Restart chrony
    sudo service chrony restart
fi
