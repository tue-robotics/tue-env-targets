#! /usr/bin/env bash

if [ -n "$TUE_CUDA" ]
then
    tue-install-pip 'tensorflow-gpu>=2.1,<2.2'
else
    tue-install-pip 'tensorflow>=2.1,<2.2'
fi
