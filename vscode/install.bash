#! /usr/bin/env bash

# Install ros extension
code --install-extension ms-iot.vscode-ros

# Configure workspace
workspacefile="${CUCR_SYSTEM_DIR}/.vscode/settings.json"
mkdir -p "${CUCR_SYSTEM_DIR}/.vscode"
if [[ ! -f "${workspacefile}" ]]
then
    cucr-install-cp workspace_settings.json "${workspacefile}"
else
    jq -s add "${workspacefile}" "${CUCR_INSTALL_CURRENT_TARGET_DIR}/workspace_settings.json" > "${workspacefile}.new"
    $? && mv "${workspacefile}.new" "${workspacefile}"  # Doesn't work at once above
fi

# Install and configure catkin tools extension
code --install-extension betwo.b2-catkin-tools
if ! catkin config --workspace "$CUCR_SYSTEM_DIR" | grep -q "DCMAKE_EXPORT_COMPILE_COMMANDS"
then
    catkin config --workspace "$CUCR_SYSTEM_DIR" --append-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
fi
