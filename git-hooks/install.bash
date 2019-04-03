#! /usr/bin/env bash

# install the global hooks
git config --global core.hooksPath "$(dirname "${BASH_SOURCE[0]}")"/git_hooks/

if dpkg --compare-versions "$(git --version | awk '{print $3}')" lt 2.9
then
    tue-install-info "Running sudo apt-get install --assume-yes git to upgrade git>2.9"
    sudo apt-get install --assume-yes git
fi
