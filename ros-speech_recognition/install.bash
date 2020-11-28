#! /usr/bin/env bash

url=$(curl -s https://api.github.com/repos/irohms-robotics/speech_recognition/releases/latest | \
    grep "browser_download_url.*model.tar.gz" | cut -d '"' -f 4)

version=$(echo "$url" | sed -e 's|/| |g' | awk '{print $7}')

dest=~/data/speech_models/"$version"

# If latest version doesn't exist then download it
if [ ! -d "$dest" ]
then
    mkdir -p "$dest"
    irohms-install-debug "wget -c -q $url -O - | tar -xz -C $dest/"
    wget -c -q "$url" -O - | tar -xz -C "$dest/"
    # Create/Update symbolic link to model directory
    ln -sfn "$dest"/model/ ~/data/speech_models/model
fi
