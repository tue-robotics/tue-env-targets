#! /usr/bin/env bash

targets="$TUE_ENV_TARGETS_DIR/*"
for target in $targets
do
    target="$(basename "$target")"
    if [[ $target != "irohms-all" ]]
    then
        irohms-install-target "$target"
    fi
done
