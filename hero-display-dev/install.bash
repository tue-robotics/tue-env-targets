#! /usr/bin/env bash

github_url="https://github.com/tue-robotics/hero-display.git"
dest="$HOME/src/hero-display"

tue-install-git "$github_url" --target-dir="$dest"
