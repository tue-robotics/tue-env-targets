#! /usr/bin/env bash

if [[ -z "${CI}" ]]
then
    tue-install-pip "torch==1.13.1+cu117 -f https://download.pytorch.org/whl/cu117/torch_stable.html"
    tue-install-pip "torchvision==0.14.1+cu117 -f https://download.pytorch.org/whl/cu117/torch_stable.html"
else
    tue-install-pip "torch==1.13.1"
    tue-install-pip "torchvision==0.14.1"
fi
