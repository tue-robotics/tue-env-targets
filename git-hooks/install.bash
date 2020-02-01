#! /usr/bin/env bash

# install the global hooks
if dpkg --compare-versions $(git --version | awk '{print $3}') lt 2.9; then
    echo "Need to upgrade git to use the git-hooks feature"
    tue-install-ppa ppa:git-core/ppa
    echo "sudo apt install git"
    sudo apt install --assume-yes git
fi

git config --global core.hooksPath $NOBLEO_DIR/installer/targets/git-hooks/git_hooks/
