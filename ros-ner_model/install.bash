#! /usr/bin/env bash

url="https://huggingface.co/PanosHuggingFace/bert-ner/resolve/main/model.pth"
dest=~/data/ner_model

if [ ! -f "${dest}"/model.pth ]
then
    mkdir -p "${dest}"
    tue-install-pipe wget --no-verbose "${url}" -O "${dest}"/model.pth.part || tue-install-error "Failed to download the ner_model weights from ${url}"
    mv "${dest}"/model.pth.part "${dest}"/model.pth
fi
