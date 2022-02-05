#! /usr/bin/env bash

arch="$(dpkg-architecture -q DEB_HOST_ARCH)"

if [[ -z "${arch}" ]]
then
    tue-install-warning "Could not retrieve the system architecture, so not installing package"
else
    # Add stable docker repository source
    if ! apt-key adv --fingerprint 0EBFCD88 &> /dev/null
    then
        tue-install-debug "Downloading gpg key of docker repo with fingerprint 0EBFCD88..."
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    else
        tue-install-debug "GPG key of docker repo with fingerprint 0EBFCD88 already exists, so not installing it."
    fi

    ppa="deb [arch=${arch}] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    tue-install-ppa-now "${ppa// /^}"  # tue-install-ppa-now needs spaces to be replaced with ^

    # Install and add user to docker group
    tue-install-system-now docker-ce docker-ce-cli containerd.io

    if [[ $(groups) != *"docker"* ]]
    then
        tue-install-debug "Adding user ${USER} to docker group and restarting services..."
        sudo usermod -aG docker "${USER}"

        # Restart the Docker daemon
        sudo service docker restart

        tue-install-info "Added user '${USER}' to docker group. A new login may be required to use docker without sudo."
    else
        tue-install-debug "Current user ${USER} already present in docker group."
    fi
fi
