#! /usr/bin/env bash

model_path="$HOME/data/gazebo_models"
url=https://github.com/osrf/gazebo_models.git

tue-install-git "$url" --target-dir="$model_path"
