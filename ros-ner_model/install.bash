#! /usr/bin/env bash

# The weights (~433 MB) are not in the git repository; ner_model looks for them in ~/data/ner_model
url="https://huggingface.co/PanosHuggingFace/bert-ner/resolve/main/model.pth"
dest=~/data/ner_model

if [ ! -f "${dest}"/model.pth ]
then
    mkdir -p "${dest}"
    # Download to a temporary file, so an interrupted download is not mistaken for the model
    tue-install-pipe wget --no-verbose "${url}" -O "${dest}"/model.pth.part || tue-install-error "Failed to download the ner_model weights from ${url}"
    mv "${dest}"/model.pth.part "${dest}"/model.pth
fi
