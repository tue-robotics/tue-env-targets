#! /usr/bin/env bash

function version_gt()
{
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1";
}

desired_version="1.3.8"
installed_version=$(python3 -c 'import nose; print(nose.__version__)')
if version_gt "$desired_version" "$installed_version"
then
    tue-install-debug "Current verison of nose: '$installed_version'. Updating nose to unreleased version $desired_version"
    tue-install-pip3 "git+https://github.com/tue-robotics/nose.git"
else
    tue-install-debug "Unreleased nose $desired_version already installed"
fi
