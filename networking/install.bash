#! /usr/bin/env bash

# Skip this target in CI
if [[ "$CI" == "true" ]]
then
    return 0
fi

# Install config file (mdns4_minimal is normally missing and should be present)

# Replace nsswitch config file
tue-install-cp nsswitch.conf /etc/nsswitch.conf

# Prevent resolving to ipv6 addresses. We're not ready for that yet
if [ ! -f /etc/avahi/avahi-daemon.conf ]
then
    tue-install-system-now avahi-daemon
fi

if grep -q 'use-ipv6=yes' /etc/avahi/avahi-daemon.conf
then
    echo "Disabling ipv6 in /etc/avahi/avahi-daemon.conf"
    sudo sed -i 's/use-ipv6=yes/use-ipv6=no/g' /etc/avahi/avahi-daemon.conf
fi

# Generate ssh key
generate_ssh="false"
# Generate ssh key when file does not exist yet
if [ ! -f ~/.ssh/id_rsa ]
then
    tue-install-debug "No ssh key exists yet"
    generate_ssh="true"
else
    # Generate new ssh key if length < 4096
    if [ "$(ssh-keygen -l -f ~/.ssh/id_rsa | awk '{print $1}')" -lt 4096 ]
    then
        tue-install-info "Generating new ssh key as length < 4096, you might need to copy the new key to the robots, GitHub, etc."
        generate_ssh="true"
    else
        tue-install-debug "ssh key available with length >= 4096"
    fi
fi

if [ $generate_ssh == "true" ]
then
    tue-install-debug "Generating ssh key"
    yes | ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
fi

# Enable persistent connection multiplexing
ssh_config=~/.ssh/config
if [ ! -f $ssh_config ]
then
    touch $ssh_config
fi
ssh_controlmasters_dir=~/.ssh/controlmasters
if [ ! -d $ssh_controlmasters_dir ]
then
    mkdir -p $ssh_controlmasters_dir
fi
tue-install-add-text ssh_persistent_connection_lines $ssh_config
