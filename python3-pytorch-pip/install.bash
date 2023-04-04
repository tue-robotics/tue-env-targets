#! /usr/bin/env bash

if [[ -z "${CI}" ]]
then
    tue-install-pip "torch==1.10.2+cu113 -i https://download.pytorch.org/whl/cu113"
    tue-install-pip "torchvision==0.11.3+cu113 -i https://download.pytorch.org/whl/cu113"
else
    tue-install-pip "torch==1.10.2+cpu -i https://download.pytorch.org/whl/cpu"
    tue-install-pip "torchvision==0.11.3+cpu -i https://download.pytorch.org/whl/cpu"
fi
