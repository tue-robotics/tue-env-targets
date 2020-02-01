#! /usr/bin/env bash

. /etc/os-release
if [ $UBUNTU_CODENAME = "xenial" ]
then
    # Install config file (mdns4_minimal is normally missing in xenial and should be present)

    # Replace nsswitch config file
    tue-install-cp nsswitch.conf /etc/nsswitch.conf
fi

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

if grep -q '#publish-aaaa-on-ipv4' /etc/avahi/avahi-daemon.conf
then
    # Also change this setting by suggestion of this bug report: https://bugzilla.redhat.com/show_bug.cgi?id=669627
    sudo sed -i 's/#publish-aaaa-on-ipv4=yes/publish-aaaa-on-ipv4=no/g' /etc/avahi/avahi-daemon.conf
fi

# Generate ssh keys when not on CI and file does not exist yet
if [[ "$CI" != "true" && ! -f ~/.ssh/id_rsa ]]
then
    tue-install-debug "Generating ssh keys"
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
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
