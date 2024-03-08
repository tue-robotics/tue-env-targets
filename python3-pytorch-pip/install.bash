#! /usr/bin/env bash

if [[ -z "${CI}" ]]
then
    tue-install-pip torch
    tue-install-pip torchvision
else
    tue-install-pip "torch==1.13 -i https://download.pytorch.org/whl/cpu"
    tue-install-pip "torchvision=0.14 -i https://download.pytorch.org/whl/cpu"
fi
