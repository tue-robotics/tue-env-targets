#! /usr/bin/env bash

# install the global hooks
if dpkg --compare-versions "$(git --version | awk '{print $3}')" lt 2.9
then
    tue-install-info "Upgrade git to > 2.9 for compatibility of git-hooks feature"
    tue-install-ppa-now ppa:git-core/ppa
    # Running here apt-get manually to force an update
    echo "[git-hooks] running command: sudo apt-get install git"
    sudo apt-get install --assume-yes git
fi

git config --global core.hooksPath "$TUE_DIR"/installer/targets/git-hooks/git_hooks/
