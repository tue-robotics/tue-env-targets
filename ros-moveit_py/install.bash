#! /usr/bin/env bash

# TEMP
# Should be removed not later than 2024-08-13
# To force removal of source pkg from workspace, because of migration to released version

pkg="moveit_py"
pkg_dir="${TUE_WS_DIR}/src/${pkg}"

if [ -e "${pkg_dir}" ]
then
    tue-install-debug "Source package found in the workspace, removing it, so the system installed version is used"
    tue-install-pipe rm "${pkg_dir}"

    tue-install-pipe /usr/bin/python3 -m colcon clean packages --log-base "${TUE_WS_DIR}"/log --base-paths "${TUE_WS_DIR}"/src --build-base "${TUE_WS_DIR}"/build --install-base "${TUE_WS_DIR}"/install --packages-select "${pkg}" -y
else
    tue-install-debug "Source package was already removed"
fi

repo_dir=$(_git_url_to_repos_dir "https://github.com/MatthijsBurgh/moveit2.git")
if [ -n "${repo_dir}" ] && [ -d "${repo_dir}" ]
then
    links=$(find "${TUE_SYSTEM_DIR}"/src -lname "${repo_dir}*")
    if [ -n "${repo_dir}" ] && [ -z "${links}" ]
    then
        tue-install-debug "No symlinks left to repo or a sub-folder of it, deleting it"
        tue-install-pipe rm -rf "${repo_dir}"
    else
        tue-install-debug "Keeping the repo as there still exist symlinks to it in the workspace"
    fi
else
    tue-install-debug "Repo already removed"
fi
