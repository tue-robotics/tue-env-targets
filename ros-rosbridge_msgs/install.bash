#! /usr/bin/env bash

# temp
# should be removed not later then 2023-04-13
# To force removal of source pkg from workspace, because of migration to released version

pkg="rosbridge_msgs"
pkg_dir="${TUE_SYSTEM_DIR}/src/${pkg}"

if [ -e "${pkg_dir}" ]
then
    tue-install-debug "Source pkg found in the workspace, removing it, so the system installed version is used"
    repo_dir=$(git -C "$(realpath "${pkg_dir}")" rev-parse --show-toplevel)
    tue-install-pipe rm "$TUE_SYSTEM_DIR/src/${pkg}"

    links=$(find "$TUE_SYSTEM_DIR"/src -lname "${repo_dir}*")
    if [ -n "${repo_dir}" ] && [ -z "${links}" ]
    then
        tue-install-debug "No symlinks left to repo or a sub-folder of it, deleting it"
        # tue-install-pipe rm -rf "${repo_dir}"
    else
        tue-install-debug "Keeping the repo as there still exist symlinks to it in the workspace"
    fi

    tue-install-pipe catkin clean --workspace "${TUE_SYSTEM_DIR}" --orphans
else
    tue-install-debug "Source pkg already removed"
fi
