#! /usr/bin/env bash

# Make sure we have git>=2.26 for sparse features
installed_version=$(git --version | awk '{print $3}')
desired_version="2.26"
if dpkg --compare-versions "${installed_version}" lt "${desired_version}"
then
    tue-install-echo "Need to upgrade git>=${desired_version} to use the sparse features"
    # install.yaml already depends on git-setup, which is parsed before executing this file.
    tue-install-apt-wait-for-lock
    tue-install-pipe sudo apt-get install --assume-yes git
else
    tue-install-debug "git version(${installed_version}) >= ${desired_version}"
fi

# Set global ignore file
if [[ ! $(git config --global core.excludesfile) ]]
then
    git config --global core.excludesfile "$(dirname "${BASH_SOURCE[0]}")"/gitignore_global
fi

# Set lg alias
if ! git config --global --get alias.lg > /dev/null
then
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
fi

# Set push default
if ! git config --global --get push.default > /dev/null
then
    git config --global push.default "current"
fi

# enable color
if ! git config --global --get color.ui > /dev/null
then
    git config --global color.ui true
fi
