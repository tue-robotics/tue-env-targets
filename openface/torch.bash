#! /usr/bin/env bash

# shellcheck disable=SC2164
pushd . > /dev/null

tue-install-info "Installing Torch"
if [ -n "$TUE_CUDA" ]
then
    tue-install-debug "Installing torch with CUDA capabilities"
    export TORCH_NVCC_FLAGS="-D__CUDA_NO_HALF_OPERATORS__"
fi

tue-install-git https://github.com/tue-robotics/torch-distro.git ~/torch
# shellcheck disable=SC2164
cd ~/torch
bash install-deps
./install.sh

# One time sourcing doesn't work. Why? Unknown.
# shellcheck disable=SC1090
source ~/.bashrc
# shellcheck disable=SC1090
source ~/.bashrc

luarocks install dpnn
luarocks install nn
luarocks install optim
luarocks install csvigo
if [ -n "$TUE_CUDA" ]
then
    luarocks install cutorch #(only with CUDA)
    luarocks install cunn #(only with CUDA)
fi
luarocks install fblualib #(only for training a DNN)
luarocks install tds #(only for training a DNN)
luarocks install torchx #(only for training a DNN)
luarocks install optnet #(optional, only for training a DNN)

#From http://serverfault.com/questions/201709/how-to-set-ld-library-path-in-ubuntu
#To define this variable, simply use (on the shell prompt):
export LD_LIBRARY_PATH=/usr/lib/openblas-base/${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

#To make it permanent, you can edit the ldconfig files. First, create a new file such as:
sudo touch /etc/ld.so.conf.d/libopenblas-base.conf

#Second, add the path in the created file
sudo sh -c 'echo "/usr/lib/openblas-base/" > /etc/ld.so.conf.d/libopenblas-base.conf'

#Finally, run ldconfig to update the cache.
sudo ldconfig

tue-install-info "torch.bash finished"

# shellcheck disable=SC2164
popd > /dev/null
