#! /usr/bin/env bash

if [ -n "$IROHMS_CUDA" ]
then
    cucr-install-pip 'tensorflow-gpu>=2.1,<2.2'
else
    cucr-install-pip 'tensorflow>=2.1,<2.2'
fi
