#! /usr/bin/env bash

curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -

# shellcheck disable=SC1091
distribution="$(. /etc/os-release;echo "$ID$VERSION_ID")"

curl -s -L https://nvidia.github.io/nvidia-docker/"$distribution"/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update

