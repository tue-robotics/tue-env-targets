#! /usr/bin/env bash

function _main
{
# shellcheck disable=SC2034
local IROHMS_INSTALL_SKIP_ROS_DEPS=normal
local targets
targets="$IROHMS_ENV_TARGETS_DIR/*"
for target in $targets
do
    target="$(basename "$target")"
    if [[ $target == "cucr-documentation-all" ]] || [[ $target == "cucr-documentation" ]]
    then
        continue
    fi

    local parent_target
    parent_target=$IROHMS_INSTALL_CURRENT_TARGET
    IROHMS_INSTALL_CURRENT_TARGET=$target

    local target_yaml_file
    target_yaml_file="$IROHMS_ENV_TARGETS_DIR"/"$target"/install.yaml
    if [ ! -f "$target_yaml_file" ]
    then
        IROHMS_INSTALL_CURRENT_TARGET=$parent_target
        continue
    fi

    local cmds
    if cmds=$("$IROHMS_INSTALL_SCRIPTS_DIR"/parse-install-yaml.py "$target_yaml_file")
    then
        for cmd in $cmds
        do
            cucr-install-debug "Original command: $cmd"
            read -r -a cmd_split <<< "${cmd//^/ }"

            local install_cmd=${cmd_split[0]}
            if [ "$install_cmd" != "cucr-install-ros" ]
            then
                IROHMS_INSTALL_CURRENT_TARGET=$parent_target
                continue
            fi

            local install_type=${cmd_split[1]}
            if [ "$install_type" != "git" ]
            then
                IROHMS_INSTALL_CURRENT_TARGET=$parent_target
                continue
            fi

            local src=${cmd_split[2]}
            if [[ "$src" != *"github.com/cucr-robotics"* ]]
            then
                IROHMS_INSTALL_CURRENT_TARGET=$parent_target
                continue
            fi

            # Executing the command
            ${cmd//^/ }

        done
    else
        cucr-install-error "Invalid install.yaml: $cmds"
    fi
    IROHMS_INSTALL_CURRENT_TARGET=$parent_target
done
}

_main
