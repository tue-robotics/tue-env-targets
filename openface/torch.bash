#! /usr/bin/env bash

# shellcheck disable=SC2164
pushd . > /dev/null

tue-install-info "Installing Torch"
if [ -n "$TUE_CUDA" ]
then
    tue-install-debug "Installing torch with CUDA capabilities"
    export TORCH_NVCC_FLAGS="-D__CUDA_NO_HALF_OPERATORS__"
fi

git clone https://github.com/torch/distro.git ~/torch --recursive
cd ~/torch || tue-install-error "Missing directory: ~/torch"
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

tue-install-info "torch.bash finished"

# shellcheck disable=SC2164
popd > /dev/null
