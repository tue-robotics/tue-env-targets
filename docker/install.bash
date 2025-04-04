#! /usr/bin/env bash

# Install and add user to docker group
tue-install-system-now docker-ce docker-ce-cli containerd.io

if [[ $(groups) != *"docker"* ]]
then
    tue-install-debug "Adding user ${USER} to docker group and restarting services..."
    tue-install-pipe sudo usermod -aG docker "${USER}"

    # Restart the Docker daemon
    tue-install-pipe sudo service docker restart

    tue-install-info "Added user '${USER}' to docker group. A new login may be required to use docker without sudo."
else
    tue-install-debug "Current user ${USER} already present in docker group."
fi
