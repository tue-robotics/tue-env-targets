#! /usr/bin/env bash

if [ -n "$TUE_CUDA" ]
then
    tue-install-pip 'tensorflow-gpu>=1.7.0,<=1.11'
else
    tue-install-pip 'tensorflow>=1.7.0,<=1.11'
fi
