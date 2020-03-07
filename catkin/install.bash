#! /usr/bin/env bash

mkdir -p "$TUE_SYSTEM_DIR" "$TUE_DEV_DIR"

if [ ! -f "$TUE_SYSTEM_DIR"/devel/setup.bash ]
then
    tue-make || tue-install-error "Error in building the system workspace"
fi

if [ ! -f "$TUE_DEV_DIR"/devel/setup.bash ]
then
    tue-make-dev || tue-install-error "Error in building the dev workspace"
fi
