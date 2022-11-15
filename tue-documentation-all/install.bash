#! /usr/bin/env bash

function _main
{
# shellcheck disable=SC2034
local TUE_INSTALL_SKIP_ROS_DEPS=normal
local targets
targets="$TUE_ENV_TARGETS_DIR/*"
for target in $targets
do
    target="$(basename "$target")"
    if [[ $target == "tue-documentation-all" ]] || [[ $target == "tue-documentation" ]]
    then
        continue
    fi

    local parent_target
    parent_target=$TUE_INSTALL_CURRENT_TARGET
    TUE_INSTALL_CURRENT_TARGET=$target

    local target_yaml_file
    target_yaml_file="$TUE_ENV_TARGETS_DIR"/"$target"/install.yaml
    if [ ! -f "$target_yaml_file" ]
    then
        TUE_INSTALL_CURRENT_TARGET=$parent_target
        continue
    fi

    local cmds
    if cmds=$("$TUE_INSTALL_SCRIPTS_DIR"/parse_install_yaml.py "$target_yaml_file")
    then
        for cmd in $cmds
        do
            tue-install-debug "Original command: $cmd"
            read -r -a cmd_split <<< "${cmd//^/ }"

            local install_cmd=${cmd_split[0]}
            if [ "$install_cmd" != "tue-install-ros" ]
            then
                TUE_INSTALL_CURRENT_TARGET=$parent_target
                continue
            fi

            local install_type=${cmd_split[1]}
            if [ "$install_type" != "git" ]
            then
                TUE_INSTALL_CURRENT_TARGET=$parent_target
                continue
            fi

            local src=${cmd_split[2]}
            if [[ "$src" != *"github.com/tue-robotics"* ]]
            then
                TUE_INSTALL_CURRENT_TARGET=$parent_target
                continue
            fi

            # Executing the command
            ${cmd//^/ }

        done
    else
        tue-install-error "Invalid install.yaml: $cmds"
    fi
    TUE_INSTALL_CURRENT_TARGET=$parent_target
done
}

_main
