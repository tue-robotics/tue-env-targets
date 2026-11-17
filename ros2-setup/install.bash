#! /usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [[ -f /etc/apt/sources.list.d/ros2.list ]]
then
    tue-install-echo "Removing the old ROS2 apt sources"
    tue-install-pipe sudo rm -f /etc/apt/sources.list.d/ros2.list* || tue-install-error "Failed to remove old ROS2 apt sources"
else
    tue-install-debug "Old ROS2 apt sources do not exist"
fi

# Check whether universe is enabled
ubuntu_name=$(lsb_release -cs)
ubuntu_version=$(lsb_release -rs)
needs_enabling_universe=true
# Check whether on ubuntu >= 24.04
if dpkg --compare-versions "${ubuntu_version}" ge "24.04"
then
    if ! "${SCRIPT_DIR}"/read_sources_files.py /etc/apt/sources.list.d/ubuntu.sources | jq -e 'all(.[]; .Components | index("universe") != null)' &>/dev/null
    then
        tue-install-debug "Not all sources have the universe repository enabled yet, going to enabled it"
    else
        tue-install-debug "All sources have the universe repository enabled"
        needs_enabling_universe=false
    fi
else
    if ! grep -h ^deb /etc/apt/sources.list 2>/dev/null | grep -P "${ubuntu_name}[a-z\-]* (?:[a-z ]*(?:[a-z]+(?: [a-z]+)*) )?universe" -q
    then
        tue-install-debug "No universe found in the sources.list, going to enable the universe repository"
    else
        tue-install-debug "Universe found in the sources.list, no need to enable it"
        needs_enabling_universe=false
    fi
fi

if [[ ${needs_enabling_universe} == true ]]
then
    tue-install-echo "Enabling universe repository"
    tue-install-pipe sudo add-apt-repository universe || tue-install-error "Failed to enable universe repository"
    tue-install-apt-get-update
else
    tue-install-debug "Universe repository is already enabled"
fi

ros_apt_source_pkg_name="ros2-apt-source"

installed_version=$(dpkg -s ${ros_apt_source_pkg_name} 2>/dev/null | grep -F "Version" | awk '{print $2}')

# Pass the token to curl via a config on stdin (-K -), so it doesn't show up in the command logged by tue-install-pipe
GITHUB_CURL_CONFIG=""
if [[ -n ${GITHUB_TOKEN} ]]
then
    GITHUB_CURL_CONFIG="header = \"Authorization: Bearer ${GITHUB_TOKEN}\""
fi
releases_api_url="https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest"
curl_tmp_dir=$(mktemp -d)
http_code=$(curl -K - -sSL -H "Accept: application/vnd.github+json" -D "${curl_tmp_dir}/headers" -o "${curl_tmp_dir}/body" -w "%{http_code}" "${releases_api_url}" <<< "${GITHUB_CURL_CONFIG}" 2> "${curl_tmp_dir}/stderr")
curl_exit_code=$?
newest_version=$(jq -r '.tag_name // empty' "${curl_tmp_dir}/body" 2>/dev/null)

if [[ ${curl_exit_code} -ne 0 ]] || [[ ${http_code} != "200" ]] || [[ -z ${newest_version} ]]
then
    error_msg="Failed to get the newest version of '${ros_apt_source_pkg_name}' from '${releases_api_url}'"
    if [[ ${curl_exit_code} -ne 0 ]]
    then
        error_msg+="\n    curl exited with code ${curl_exit_code}: $(<"${curl_tmp_dir}/stderr")"
    else
        error_msg+="\n    HTTP status: ${http_code}"
        github_message=$(jq -r '.message // empty' "${curl_tmp_dir}/body" 2>/dev/null)
        if [[ -n ${github_message} ]]
        then
            error_msg+="\n    GitHub message: ${github_message}"
        elif [[ -z ${newest_version} ]]
        then
            error_msg+="\n    No 'tag_name' found in the response: $(head -c 500 "${curl_tmp_dir}/body")"
        fi
        ratelimit_remaining=$(grep -i "^x-ratelimit-remaining:" "${curl_tmp_dir}/headers" | tail -n 1 | awk '{print $2}' | tr -d '\r')
        if [[ ${ratelimit_remaining} == "0" ]]
        then
            ratelimit_reset=$(grep -i "^x-ratelimit-reset:" "${curl_tmp_dir}/headers" | tail -n 1 | awk '{print $2}' | tr -d '\r')
            error_msg+="\n    GitHub API rate limit exceeded, resets at $(date -d "@${ratelimit_reset}" 2>/dev/null || echo "unknown")"
            if [[ -z ${GITHUB_TOKEN} ]]
            then
                error_msg+="\n    Set GITHUB_TOKEN to get a higher rate limit"
            fi
        fi
    fi
    rm -rf "${curl_tmp_dir}"
    tue-install-error "${error_msg}"
fi
rm -rf "${curl_tmp_dir}"

needs_install=true
if [[ -n ${installed_version} ]]
then
    if [[ ${installed_version} == "${newest_version}~${ubuntu_name}" ]]
    then
        tue-install-debug "The most recent version of '${ros_apt_source_pkg_name}' is already installed '${installed_version}'"
        needs_install=false
    else
        tue-install-debug "Newer version, '${newest_version}', of '${ros_apt_source_pkg_name}' available, currently installed: '${installed_version}'"
    fi
else
    tue-install-debug "No version of '${ros_apt_source_pkg_name}' installed"
fi

if [[ ${needs_install} == true ]]
then
    tue-install-debug "Going to install ${ros_apt_source_pkg_name}"
    tue-install-pipe curl -K - -fL -o /tmp/${ros_apt_source_pkg_name}.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${newest_version}/${ros_apt_source_pkg_name}_${newest_version}.${ubuntu_name}_all.deb" <<< "${GITHUB_CURL_CONFIG}" || tue-install-error "Failed to download ROS2 apt source debian"
    tue-install-dpkg /tmp/${ros_apt_source_pkg_name}.deb
    tue-install-apt-get-update
fi

