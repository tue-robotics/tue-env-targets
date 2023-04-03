#! /usr/bin/env bash

if [[ -z "${CI}" ]]
then
    tue-install-pip "torch==1.13.1+cu117 -i https://download.pytorch.org/whl/cu117"
    tue-install-pip "torchvision==0.14.1+cu117 -i https://download.pytorch.org/whl/cu117"
else
    tue-install-pip "torch==1.13.1+cpu -i https://download.pytorch.org/whl/cpu"
    tue-install-pip "torchvision==0.14.1+cpu -i https://download.pytorch.org/whl/cpu"
fi
