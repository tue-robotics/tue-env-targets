#! /usr/bin/env bash

if [ -n "$TUE_CUDA" ]
then
    tue-install-pip 'tensorflow-gpu>=2.0,<2.1'
else
    tue-install-pip 'tensorflow>=2.0,<2.1'
fi
