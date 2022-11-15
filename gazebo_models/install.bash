#! /usr/bin/env bash

model_path="$HOME/data/gazebo_models"

# temp; start
# repo has moved to github, so remove mercurial folder
if [ ! -d "$model_path/.git" ]
then
    tue-install-debug "Removing mercurial version of gazebo_models, replacing by git"
    rm -rf "$model_path"
fi
# temp; end

url=https://github.com/osrf/gazebo_models.git
tue-install-git "$url" --target-dir="$model_path"
