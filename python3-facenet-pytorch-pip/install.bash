#! /usr/bin/env bash

args=()
if [[ "${CI}" == true ]]
then
    args+=("--extra-index-url" "https://download.pytorch.org/whl/cpu")
fi

tue-install-pip3 facenet-pytorch "${args[@]}"
