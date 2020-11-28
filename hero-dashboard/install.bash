#! /usr/bin/env bash
set -e

if [ -f "$IROHMS_BIN"/hero_dashboard.d/hero-dashboard ]
then
    irohms-install-debug "Removing old release folder"
    rm -rf "$IROHMS_BIN"/hero_dashboard.d
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck disable=SC1090
"$DIR"/get-releases | source "$DIR"/process-releases

# Shortcuts
irohms-install-cp shortcuts/hero-dashboard.desktop ~/.local/share/applications/hero-dashboard.desktop
irohms-install-cp shortcuts/icons/hsr.png /usr/share/pixmaps/irohms/hsr.png

set +e
