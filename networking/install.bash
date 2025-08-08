#! /usr/bin/env bash

if [ "$(lsb_release -cs)" == "xenial" ]
then
    # Install config file (mdns4_minimal is normally missing in xenial and should be present)

    # Replace nsswitch config file
    tue-install-cp nsswitch.conf /etc/nsswitch.conf
fi

# Prevent resolving to ipv6 addresses. We're not ready for that yet
if grep -q 'use-ipv6=yes' /etc/avahi/avahi-daemon.conf
then
    tue-install-echo "Disabling ipv6 in /etc/avahi/avahi-daemon.conf"
    sudo sed -i 's/use-ipv6=yes/use-ipv6=no/g' /etc/avahi/avahi-daemon.conf
fi

if grep -q '#publish-aaaa-on-ipv4' /etc/avahi/avahi-daemon.conf
then
    # Also change this setting by suggestion of this bug report: https://bugzilla.redhat.com/show_bug.cgi?id=669627
    sudo sed -i 's/#publish-aaaa-on-ipv4=yes/publish-aaaa-on-ipv4=no/g' /etc/avahi/avahi-daemon.conf
fi

## SSH
SSH_CONFIG=~/.ssh/config
SSH_CONTROLMASTERS_DIR=~/.ssh/controlmasters
SSH_KEY_FILE=~/.ssh/id_ed25519

# Allowed key types and their required lengths
declare -A ALLOWED_KEY_LENGTHS
ALLOWED_KEY_LENGTHS[rsa]=4096
ALLOWED_KEY_LENGTHS[ed25519]=256

# Generate ssh key
GENERATE_SSH="true"
# Generate ssh key when file does not exist yet
if ssh-add -l &>/dev/null
then
    while IFS= read -r line
    do
        key_length=$(echo "${line}" | awk '{print $1}')
        key_type=$(echo "${line}" | awk '{print $NF}' | tr '[:upper:]' '[:lower:]' | tr -d '()')
        required_length="${ALLOWED_KEY_LENGTHS[${key_type}]}"

        if [[ -n "${required_length}" && "${key_length}" -ge "${required_length}" ]]
        then
            tue-install-debug "Valid ${key_type} key found in agent: ${key_length} bits"
            GENERATE_SSH="false"
            break
        fi
    done < <(ssh-add -l)
else
    tue-install-debug "No SSH keys currently loaded in the agent."
fi

if [[ ${GENERATE_SSH} == "true" ]]
then
    echo
    while true
    do
        exec < /dev/tty
        read -p $'\e[1m[networking]\e[0m: No valid ssh key found. Would you like to generate a new ED25519 key? [y/n] ' -n 1 -r
        exec <&-
        echo
        if [[ ${REPLY} =~ ^[Yy]$ ]]
        then
            tue-install-debug "Generating new SSH key (ED25519)"
            [[ -f ${SSH_KEY_FILE} ]] && tue-install-pipe ssh-add -d ${SSH_KEY_FILE}
            yes | ssh-keygen -t ed25519 -N "" -f "${SSH_KEY_FILE}"
            rm -r ${SSH_CONTROLMASTERS_DIR:?}/* 2>/dev/null
            tue-install-pipe ssh-add ${SSH_KEY_FILE}
            tue-install-info "Succesfully generated a new SSH key (${SSH_KEY_FILE}), don't forget to register the new public key at the required services"
            break
        elif [[ ${REPLY} =~ ^[Nn]$ ]]
        then
            tue-install-info "Skipping SSH key generation"
            break
        fi
        echo -e "\e[1mPlease answer with 'y' or 'n'\e[0m"
    done
fi

# Enable persistent connection multiplexing
[[ -f ${SSH_CONFIG} ]] || touch ${SSH_CONFIG}
[[ -d ${SSH_CONTROLMASTERS_DIR} ]] || mkdir -p ${SSH_CONTROLMASTERS_DIR}
tue-install-add-text ssh_persistent_connection_lines ${SSH_CONFIG}
