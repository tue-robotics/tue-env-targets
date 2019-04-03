#! /usr/bin/env bash

if [[ -n "$CI" ]]
then
    # Skip this target in CI. As models aren't used, but takes a lot of time to download them.
    return 0
fi

tue-install-system-now mercurial

model_path=$HOME/data/gazebo_models
if [ ! -d $model_path ]
then
    hg clone https://bitbucket.org/osrf/gazebo_models $model_path
else
    cd $model_path
    hg pull -f
    hg update
fi
