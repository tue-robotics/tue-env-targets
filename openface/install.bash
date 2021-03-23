#! /usr/bin/env bash

if [ ! -d "${HOME}"/openface ]
then
    tue-install-git https://github.com/cmusatyalab/openface.git  ~/openface

    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    # shellcheck disable=SC1090
    # source "$DIR"/dlib.bash
    # shellcheck disable=SC1090
    source "$DIR"/torch.bash

    # shellcheck disable=SC2164
    cd "${HOME}"/openface
    python2 setup.py install --user

    models/get-models.sh
fi

if [[ $(python2 -c "import dlib") -eq 1 ]]
then
    tue-install-error "DLIB is not properly installed"
fi

if [[ $(python2 -c "import cv2") -eq 1 ]]
then
    tue-install-error "opencv2 is not properly installed"
fi

if [[ $(python2 -c "import openface") -eq 1 ]]
then
    tue-install-error "openface is not properly installed"
fi
