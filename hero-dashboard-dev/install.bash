#! /usr/bin/env bash

github_url="https://github.com/tue-robotics/hero-dashboard.git"
dest="$HOME/src/hero-dashboard"

tue-install-git "$github_url" --target-dir="$dest"
