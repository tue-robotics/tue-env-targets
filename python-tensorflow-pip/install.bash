#! /usr/bin/env bash

if [ -n "$IROHMS_CUDA" ]
then
    irohms-install-pip 'tensorflow-gpu>=2.1,<2.2'
else
    irohms-install-pip 'tensorflow>=2.1,<2.2'
fi
