#! /usr/bin/env bash
set -e

# Check config file
if ! cmp /etc/chrony/chrony.conf "$(dirname "${BASH_SOURCE[0]}")"/chrony.conf --quiet
then
    tue-install-echo "Chrony config is probably not correct, will copy"

    # Copy and backup old config
    tue-install-pipe sudo install --backup=numbered --compare --verbose "$(dirname "${BASH_SOURCE[0]}")"/chrony.conf /etc/chrony/chrony.conf

    # Restart chrony
    tue-install-pipe sudo service chrony restart
fi

set +e
