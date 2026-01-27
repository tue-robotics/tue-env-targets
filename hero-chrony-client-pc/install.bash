#! /usr/bin/env bash
set -e

service_name="chrony.service"

needs_restart=false
# Check config file
if ! cmp /etc/chrony/chrony.conf "$(dirname "${BASH_SOURCE[0]}")"/chrony.conf --quiet
then
    tue-install-echo "Chrony config is not correct, will copy"
    needs_restart=true

    # Copy and backup old config
    tue-install-pipe sudo install --backup=numbered --compare --verbose "$(dirname "${BASH_SOURCE[0]}")"/chrony.conf /etc/chrony/chrony.conf
else
    tue-install-debug "Chrony config is the same, not copying"
    if ! systemctl is-active -q ${service_name}
    then
        tue-install-debug "Chrony is not active yet"
        needs_restart=true
    fi
fi

if [[ ${needs_restart} == true ]]
then
    tue-install-echo "(Re)starting chrony"
    tue-install-pipe sudo systemctl restart ${service_name}
else
    tue-install-debug "No need to restart chrony"
fi

if ! systemctl is-enabled -q ${service_name}
then
    tue-install-echo "Chrony is not enabled yet"
    tue-install-pipe sudo systemctl enable ${service_name}
fi

unset needs_restart service_name

set +e
