#! /usr/bin/env bash

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
