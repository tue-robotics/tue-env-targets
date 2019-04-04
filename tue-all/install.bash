#! /usr/bin/env bash

targets="$TUE_ENV_TARGETS_DIR"/*
for target in $targets
do
    target="$(basename "$target")"
    if [[ $target != "tue-all" ]]
    then
        tue-install-target "$target"
    fi
done
