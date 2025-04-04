#! /usr/bin/env bash

# Add user to docker group
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
