#! /usr/bin/env bash

pv=3
if [ "$TUE_ROS_DISTRO" == "melodic" ] || [ "$TUE_ROS_DISTRO" == "xenial" ]
then
    pv=2
fi

if [ ! -d "${HOME}"/src/openface ]
then
    tue-install-git https://github.com/cmusatyalab/openface.git  ~/src/openface

    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    # shellcheck disable=SC1090
    source "$DIR"/torch.bash

    # shellcheck disable=SC2164
    cd "${HOME}"/src/openface
    python${pv} setup.py install --user

    models/get-models.sh
fi

if [[ $(python${pv} -c "import dlib") -eq 1 ]]
then
    tue-install-error "DLIB is not properly installed"
fi

if [[ $(python${pv} -c "import cv2") -eq 1 ]]
then
    tue-install-error "opencv2 is not properly installed"
fi

if [[ $(python${pv} -c "import openface") -eq 1 ]]
then
    tue-install-error "openface is not properly installed"
fi
