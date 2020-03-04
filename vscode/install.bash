#! /usr/bin/env bash

tue-install-snap-now code

tue-install-system-now default-jre

# Install ros extension
code --install-extension ms-iot.vscode-ros

# Configure workspace
workspacefile="${TUE_SYSTEM_DIR}/.vscode/settings.json"
mkdir -p "${TUE_SYSTEM_DIR}/.vscode"
if [[ ! -f "${workspacefile}" ]]
then
    tue-install-cp workspace_settings.json "${workspacefile}"
else
    tue-install-system-now jq
    jq -s add "${workspacefile}" "${TUE_INSTALL_CURRENT_TARGET_DIR}/workspace_settings.json" > "${workspacefile}.new"
    $? && mv "${workspacefile}.new" "${workspacefile}"  # Doesn't work at once above
fi

# Install and configure catkin tools extension
code --install-extension betwo.b2-catkin-tools
if ! catkin config --workspace "$TUE_SYSTEM_DIR" | grep -q "DCMAKE_EXPORT_COMPILE_COMMANDS"
then
    catkin config --workspace "$TUE_SYSTEM_DIR" --append-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
fi
