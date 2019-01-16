#! /usr/bin/env bash
script_dir=$(dirname "${BASH_SOURCE[0]}")

# install the global hooks
git config --global core.hooksPath $script_dir/git_hooks/

if dpkg --compare-versions $(git --version | awk '{print $3}') lt 2.9; then
    tue-install-warning "Please perform a
    sudo apt install git
afterwards to upgrade the git version to allow git-hooks"
fi
