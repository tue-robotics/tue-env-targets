#! /usr/bin/env bash

if [ -n "$TUE_CUDA" ]
then
    tue-install-pip 'tensorflow-gpu'
else
    tue-install-pip 'tensorflow'
fi
