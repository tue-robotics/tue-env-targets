#! /usr/bin/env bash
#
# Bash script to install target kaldi

# Clone kaldi fork from tue-robotics (only latest commit)
KALDI_REPO="https://github.com/tue-robotics/kaldi.git"
KALDI_HOME=~/src/kaldi_speech
KALDI_REPO_BRANCH="develop"

# By default, set the previous commit to -1, which will trigger a 'make'
prev="-1"

# Install dependencies
# TODO: Change this to tue-install-targets --now $name_of_targets
tue-install-system-now zlib-devel zlib1g-dev automake autoconf patch grep \
    bzip2 gzip wget sox libtool subversion gawk python python3 libatlas3-base \
    swig zip p7zip-full

# If the directory already exists
if [ -d "$KALDI_HOME" ]
then
    cd "$KALDI_HOME"
    current_remote=$(git config --get remote.origin.url) # get the remote

    # If the kaldi_speech is pointing to the wrong Remote, correct it
    if [ "$current_remote" != "$KALDI_REPO" ]
    then
        tue-install-debug "Updated kaldi_speech remote from $REMOTE to $KALDI_REPO"
        git remote set-url origin "$KALDI_REPO"
    fi

    # Get current branch
    current_branch=$(git symbolic-ref --short HEAD)

    # Change to the techunited branch
    if [ "$current_branch" != "$KALDI_REPO_BRANCH" ]
    then
        git checkout "$KALDI_REPO_BRANCH"
    fi

    # Git is set-up correctly, so record the previous commit
    prev=$(git rev-list HEAD -n 1)
fi

# tue-install-git will decide if clone or pull is needed
tue-install-git "$KALDI_REPO" "$KALDI_HOME" "$KALDI_REPO_BRANCH"

# Build toolkit if needed
cd "$KALDI_HOME"
if [ "$prev" != "$(git rev-list HEAD -n 1)" ]; then
    tue-install-debug "Building kaldi_speech"
    ./install.bash --build || tue-install-error "Kaldi build error."
else
    tue-install-debug "kaldi_speech not updated, so not rebuilding"
fi

