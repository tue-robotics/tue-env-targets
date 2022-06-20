#! /usr/bin/env bash

# Bash script to install target kaldi

# Clone kaldi fork from cucr-robotics (only latest commit)
KALDI_REPO="https://github.com/cucr-robotics/kaldi.git"
KALDI_HOME=~/src/kaldi_speech
KALDI_REPO_BRANCH="develop"

# If executing in Docker and Kaldi build exists, do nothing
kaldi_exists=true
{ status="$(cat $KALDI_HOME/STATUS)" && [ "$status" == "ALL OK" ]; } || kaldi_exists=false

if [ -n "$DOCKER" ] && [ "$kaldi_exists" == "true" ]
then
    cucr-install-debug "Kaldi installation in Docker exists. Doing nothing."
    return 0
fi

# Get the version of Ubuntu
# shellcheck disable=SC1091
source /etc/lsb-release

# By default, set the previous commit to -1, which will trigger a 'make'
prev="-1"

# Install dependencies
# TODO: Change this to cucr-install-targets --now $name_of_targets
cucr-install-system-now zlib1g-dev automake autoconf patch grep \
    bzip2 gzip wget sox libtool subversion gawk python python3 libatlas3-base \
    libatlas-base-dev swig zip p7zip-full python-six libglib2.0-dev \
    flac graphviz libopenblas-dev

# Numpy later than 1.15.0 is required
cucr-install-pip2-now "numpy>=1.15.0" ninja cmake

# If the directory already exists
if [ -d "$KALDI_HOME" ]
then
    # shellcheck disable=SC2164
    cd "$KALDI_HOME"
    current_remote=$(git config --get remote.origin.url) # get the remote

    # If the kaldi_speech is pointing to the wrong Remote, correct it
    if [ "$(_git_https_or_ssh "$current_remote")" != "$KALDI_REPO" ]
    then
        cucr-install-debug "Updated kaldi_speech remote from $REMOTE to $KALDI_REPO"
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

# cucr-install-git will decide if clone or pull is needed
cucr-install-git "$KALDI_REPO" "$KALDI_HOME" "$KALDI_REPO_BRANCH"

# Build toolkit if needed
# shellcheck disable=SC2164
cd "$KALDI_HOME"
if [ "$prev" != "$(git rev-list HEAD -n 1)" ]
then
    # Set g++ version restrictions only for Ubuntu 16.04 due to limitations by CUDA
    if [ "$DISTRIB_RELEASE" == "16.04" ]
    then
        cucr-install-debug "Checking g++ version"
        gpp_version=$(g++ -dumpversion)
        cucr-install-debug "g++ version found: $gpp_version"

        gpp_version_num=$(echo "$gpp_version" | sed 's/\./ /g' | xargs printf "%d%02d%02d")
        if [ "$gpp_version_num" -gt 70000 ]
        then
            cucr-install-debug "Unsupported g++ version. Need g++ < 7.0.*"
            export CXX=g++-5
            gpp_version=$($CXX -dumpversion) || { cucr-install-error "Required g++ version not found"; }
            cucr-install-debug "Changed g++ version to $gpp_version"
        else
            export CXX=g++
        fi
    fi

    cucr-install-debug "Building kaldi_speech"
    ./install.bash --cucr || cucr-install-error "Kaldi build error."
else
    cucr-install-debug "kaldi_speech not updated, so not rebuilding"
fi
