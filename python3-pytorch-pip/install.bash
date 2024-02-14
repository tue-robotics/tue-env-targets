#! /usr/bin/env bash

if [[ -z "${CI}" ]]
then
    tue-install-pip torch
    tue-install-pip torchvision
else
    tue-install-pip "torch -i https://download.pytorch.org/whl/cpu"
    tue-install-pip "torchvision -i https://download.pytorch.org/whl/cpu"
fi
