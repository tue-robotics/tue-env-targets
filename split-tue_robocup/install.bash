#! /usr/bin/env bash

target=~/src/git-split-branch/git-split-branch
link="${TUE_BIN}"/git-split-branch

if [[ -e "${link}" ]]
then
    tue-install-debug "link exists"
    if [[ ! -L "${link}" ]]
    then
        tue-install-debug "link it not a link"
    else
        tue-install-debug "link is a link"
        if [[ "$(realpath "${link}")" != "$(realpath "${target}")" ]]
        then
            tue-install-debug "link doesn't match the target"
        fi
    fi
fi

tue-install-pipe ln -s "${target}" "${link}"
