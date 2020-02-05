#! /usr/bin/env bash

if [[ -n "$CI" ]]
then
    # Skip this target in CI. As models aren't used, but takes a lot of time to download them.
    return 0
fi

model_path="$HOME/data/gazebo_models"
url=https://bitbucket.org/osrf/gazebo_models
tue-install-hg "$url" "$model_path"
