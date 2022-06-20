#! /usr/bin/env bash

if [[ -n "$CI" ]]
then
    # Skip this target in CI. As models aren't used, but takes a lot of time to download them.
    return 0
fi

model_path="$HOME/data/gazebo_models"

# temp; start
# repo has moved to github, so remove mercurial folder
if [ ! -d "$model_path/.git" ]
then
    cucr-install-debug "Removing mercurial version of gazebo_models, replacing by git"
    rm -rf "$model_path"
fi
# temp; end

url=https://github.com/osrf/gazebo_models.git
cucr-install-git "$url" "$model_path"
