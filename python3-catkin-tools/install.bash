# TEMP: should be remove not later then 2022-06-24
# Also delete check_installed_version.py

catkin_version=$(catkin --version 2>/dev/null | awk 'NR==1{print $2}')

if dpkg --compare-versions "${catkin_version}" lt 0.8.5
then
    tue-install-info "Upgrading catkin-tools to >= 0.8.5, as 0.8.3 and 0.8.4 are broken"
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    while ! install_location=$("$DIR"/check_installed_version.py)
    do
        if [ "$install_location" == "user" ]
        then
            tue-install-info "Removing pip user installed version of catkin-tools"
            tue-install-pipe pip uninstall catkin-tools -y
        elif [ "$install_location" == "system" ]
        then
            tue-install-info "Removing pip system installed version of catkin-tools"
            tue-install-pipe sudo -H pip uninstall catkin-tools -y
        else
            tue-install-error "pip install location can only by user or system"
        fi
    done
    # --reinstall is needed as a system installed pip version will replace /usr/bin/catkin, which gets deleted
    tue-install-pipe sudo apt-get install --assume-yes python3-catkin-tools --reinstall
else
    tue-install-debug "Not updating catkin-tools. Installed version: ${catkin_version}"
fi
