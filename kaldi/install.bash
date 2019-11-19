#! /usr/bin/env bash

# Bash script to install target kaldi

# Clone kaldi fork from tue-robotics (only latest commit)
KALDI_REPO="https://github.com/tue-robotics/kaldi.git"
KALDI_HOME=~/src/kaldi_speech
KALDI_REPO_BRANCH="develop"

# If executing in Docker and Kaldi build exists, do nothing
kaldi_exists=true
{ status="$(cat $KALDI_HOME/STATUS)" && [ "$status" == "ALL OK" ]; } || kaldi_exists=false

if [ -n "$DOCKER" ] && [ "$kaldi_exists" == "true" ]
then
    tue-install-debug "Kaldi installation in Docker exists. Doing nothing."
    return 0
fi

# Get the version of Ubuntu
# shellcheck disable=SC1091
source /etc/lsb-release

# By default, set the previous commit to -1, which will trigger a 'make'
prev="-1"

# Install dependencies
# TODO: Change this to tue-install-targets --now $name_of_targets
tue-install-system-now zlib1g-dev automake autoconf patch grep \
    bzip2 gzip wget sox libtool subversion gawk python python3 libatlas3-base \
    swig zip p7zip-full python-six libglib2.0-dev \
    flac graphviz

# Numpy later than 1.15.0 is required
pip2 install --user "numpy>=1.15.0"

# If the directory already exists
if [ -d "$KALDI_HOME" ]
then
    # shellcheck disable=SC2164
    cd "$KALDI_HOME"
    current_remote=$(git config --get remote.origin.url) # get the remote

    # If the kaldi_speech is pointing to the wrong Remote, correct it
    if [ "$(_github_https "$current_remote")" != "$KALDI_REPO" ]
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
# shellcheck disable=SC2164
cd "$KALDI_HOME"
if [ "$prev" != "$(git rev-list HEAD -n 1)" ]
then
    # Set g++ version restrictions only for Ubuntu 16.04 due to limitations by CUDA
    if [ "$DISTRIB_RELEASE" == "16.04" ]
    then
        tue-install-debug "Checking g++ version"
        gpp_version=$(g++ -dumpversion)
        tue-install-debug "g++ version found: $gpp_version"

        gpp_version_num=$(echo "$gpp_version" | sed 's/\./ /g' | xargs printf "%d%02d%02d")
        if [ "$gpp_version_num" -gt 70000 ]
        then
            tue-install-debug "Unsupported g++ version. Need g++ < 7.0.*"
            export CXX=g++-5
            gpp_version=$($CXX -dumpversion) || { tue-install-error "Required g++ version not found"; }
            tue-install-debug "Changed g++ version to $gpp_version"
        else
            export CXX=g++
        fi
    fi

    tue-install-debug "Building kaldi_speech"
    ./install.bash --tue || tue-install-error "Kaldi build error."
else
    tue-install-debug "kaldi_speech not updated, so not rebuilding"
fi

