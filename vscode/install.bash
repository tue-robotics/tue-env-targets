#! /usr/bin/env bash

# Install extensions fitting to tue flow
## ROS extension
## Extension for catkin tools
## F9 shortcut for sorting imports / package.xml / CMakeLists.txt etc
# --force install to make sure newest versions are installed on tue-get update
code --install-extension ms-iot.vscode-ros\
     --install-extension betwo.b2-catkin-tools\
     --install-extension tyriar.sort-lines\
     --force

# Configure workspace
workspacefile="${TUE_ENV_WS_DIR}/.vscode/settings.json"
mkdir -p "${TUE_ENV_WS_DIR}/.vscode"
if [[ ! -f "${workspacefile}" ]]
then
    tue-install-cp workspace_settings.json "${workspacefile}"
else
    if ! jq -s add "${workspacefile}" "${TUE_INSTALL_CURRENT_TARGET_DIR}/workspace_settings.json" > "${workspacefile}.new"
    then
        mv "${workspacefile}.new" "${workspacefile}"  # Doesn't work at once above
    fi
fi

if [[ "${TUE_ENV_ROS_VERSION}" == "1" ]]
then
    # Install and configure catkin tools extension
    if ! python3 "$(command -v catkin)" config --workspace "${TUE_ENV_WS_DIR}" | grep -q "DCMAKE_EXPORT_COMPILE_COMMANDS"
    then
        python3 "$(command -v catkin)" config --workspace "${TUE_ENV_WS_DIR}" --append-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    fi
fi

# Configure to build only active package
tasksfile="${TUE_ENV_WS_DIR}/.vscode/tasks.json"
if [[ ! -f "${tasksfile}" ]]  # If user already has one, don't overwrite
then
    tue-install-cp tasks.json "${tasksfile}"
fi
