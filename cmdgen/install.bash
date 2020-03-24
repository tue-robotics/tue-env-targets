#! /usr/bin/env bash

github_url="https://github.com/tue-robotics/GPSRCmdGen.git"
dest="$HOME/src/GPSRCmdGen"

# by default, set the previous commit to -1, which will trigger a 'make'
prev="-1"

if [ -d "$dest" ]
then
    # shellcheck disable=SC2164
    cd "$dest"
    current_url=$(git config --get remote.origin.url) # get the remote

    # if the GSPRCmdGen is pointing to the wrong remote, correct it
    if [ "$(_git_https_or_ssh "$current_url")" != "$github_url" ]
    then
        tue-install-debug "The GPSRCmdGen is still pointing to old remote, will be changed to tue-fork"
        git remote set-url origin $github_url
    fi

    # Git is set-up correctly, so record the previous commit
    prev=$(git rev-list HEAD -n 1)
fi

# tue-install-git will decide if clone or pull is needed
tue-install-git $github_url "$dest"

# install mono if not yet installed
hash mono 2> /dev/null || tue-install-system-now mono-complete

# make if needed
# shellcheck disable=SC2164
cd "$dest"
if [ "$prev" != "$(git rev-list HEAD -n 1)" ]; then
    tue-install-debug "Making GPSRCmdGen"
    make
else
    tue-install-debug "GPSRCmdGen not updated, so not needed to make again"
fi
