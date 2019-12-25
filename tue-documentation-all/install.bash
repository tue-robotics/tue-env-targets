#! /usr/bin/env bash

function main
{
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
    if cmds=$("$TUE_INSTALL_SCRIPTS_DIR"/parse-install-yaml.py "$target_yaml_file")
    then
        for cmd in $cmds
        do
            tue-install-debug "Original command: $cmd"
            mapfile -t cmd <<< "${cmd//^/ }"

            if [ "${cmd[0]}" != "tue-install-ros" ]
            then
                TUE_INSTALL_CURRENT_TARGET=$parent_target
                continue
            fi

            local install_type=${cmd[1]}
            if [ "$install_type" != "git" ]
            then
                TUE_INSTALL_CURRENT_TARGET=$parent_target
                continue
            fi

            local src=${cmd[2]}
            if [[ "$src" != *"github.com/tue-robotics"* ]]
            then
                TUE_INSTALL_CURRENT_TARGET=$parent_target
                continue
            fi

            local sub_dir=${cmd[3]}
            local version=${cmd[4]}

            local ros_pkg_name=${TUE_INSTALL_CURRENT_TARGET#ros-}

            local ros_pkg_dir="$ROS_PACKAGE_INSTALL_DIR"/"$ros_pkg_name"
            local repos_dir="$TUE_REPOS_DIR"/"$src"
            # replace spaces with underscores
            repos_dir=${repos_dir// /_}
            # now, clean out anything that's not alphanumeric or an underscore
            repos_dir=${repos_dir//[^a-zA-Z0-9\/\.-]/_}

            tue-install-git "$src" "$repos_dir" "$version"

            if [ -d "$repos_dir" ]
            then
                if [ ! -d "$repos_dir"/"$sub_dir" ]
                then
                    tue-install-error "Subdirectory '$sub_dir' does not exist for URL '$src'."
                fi

                if [ -L "$ros_pkg_dir" ]
                then
                    # Test if the current symbolic link points to the same repository dir. If not, give a warning
                    # because it means the source URL has changed
                    if [ ! "$ros_pkg_dir" -ef "$repos_dir"/"$sub_dir" ]
                    then
                        tue-install-info "URL has changed to $src/$sub_dir"
                        rm "$ros_pkg_dir"
                        ln -s "$repos_dir"/"$sub_dir" "$ros_pkg_dir"
                    fi
                elif [ ! -d "$ros_pkg_dir" ]
                then
                    # Create a symbolic link to the system workspace
                    ln -s "$repos_dir"/"$sub_dir" "$ros_pkg_dir"
                fi
            else
                tue-install-error "Checking out $src was not successful."
            fi
        done
    else
        tue-install-error "Invalid install.yaml: $cmds"
    fi
    TUE_INSTALL_CURRENT_TARGET=parent_target
done
}

main

#cmds=$("$TUE_INSTALL_SCRIPTS_DIR"/parse-install-yaml.py "$install_file".yaml)
