#! /usr/bin/env bash

if [ ! -d ~/openface ]
then
    tue-install-git https://github.com/cmusatyalab/openface.git  ~/openface
    tue-install-system-now python-numpy python-pandas python-scipy python-sklearn python-skimage

    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    # shellcheck disable=SC1090
    source "$DIR"/dlib.bash
    # shellcheck disable=SC1090
    source "$DIR"/torch.bash

    # shellcheck disable=SC2164
    cd ~/openface
    sudo python2 setup.py install

    models/get-models.sh

    if [[ $(python -c "import dlib") -eq 1 ]]; then
        echo "DLIB is not properly installed"
    fi

    if [[ $(python -c "import cv2") -eq 1 ]]; then
        echo "opencv2 is not properly installed"
    fi

    if [[ $(python -c "import openface") -eq 1 ]]; then
        echo "openface is not properly installed"
    fi

fi
