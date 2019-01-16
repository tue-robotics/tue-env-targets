#! /usr/bin/env bash
targets=$(ls $TUE_ENV_TARGETS_DIR)
for target in $targets
do
    if [[ $target != "tue-all" ]]
    then
        tue-install-target $target
    fi
done
