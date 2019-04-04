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


#From http://serverfault.com/questions/201709/how-to-set-ld-library-path-in-ubuntu
#To define this variable, simply use (on the shell prompt):
export LD_LIBRARY_PATH=/usr/lib/openblas-base/${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

#To make it permanent, you can edit the ldconfig files. First, create a new file such as:
sudo touch /etc/ld.so.conf.d/libopenblas-base.conf

#Second, add the path in the created file
sudo sh -c 'echo "/usr/lib/openblas-base/" > /etc/ld.so.conf.d/libopenblas-base.conf'

#Finally, run ldconfig to update the cache.
sudo ldconfig

#Remove source files
sudo rm -rf /tmp/dlib

tue-install-info "dlib.bash finished"

# shellcheck disable=SC2164
popd > /dev/null
