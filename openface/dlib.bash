#! /usr/bin/env bash

# shellcheck disable=SC2164
pushd . > /dev/null

tue-install-info "Installing DLib"

mkdir -p /tmp/dlib
# shellcheck disable=SC2164
cd /tmp/dlib
wget https://github.com/davisking/dlib/releases/download/v18.16/dlib-18.16.tar.bz2
tar xf dlib-18.16.tar.bz2
cd dlib-18.16/python_examples || tue-install-error "Missing directory: /tmp/dlib/dlib-18.16/python_examples"
mkdir build
# shellcheck disable=SC2164
cd build
cmake ../../tools/python
cmake --build . --config Release
sudo cp dlib.so /usr/local/lib/python2.7/dist-packages

#Remove source files
sudo rm -rf /tmp/dlib

tue-install-info "dlib.bash finished"

# shellcheck disable=SC2164
popd > /dev/null
