#! /usr/bin/env bash

# check for git-extras
if [ ! -f /usr/local/bin/git-extras ]
then
    # https://github.com/tj/git-extras
    cd /tmp && git clone --depth 1 https://github.com/visionmedia/git-extras.git && cd git-extras && sudo make install
fi

# Unset old path, targets have moved
if [[ $(git config --global core.excludesfile) == "$TUE_DIR/installer/targets/git/gitignore_global" ]]
then
    git config --global --unset core.excludesfile
fi

# Set global ignore file
if [[ ! $(git config --global core.excludesfile) ]]
then
    git config --global core.excludesfile $(dirname "${BASH_SOURCE[0]}")/gitignore_global
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
