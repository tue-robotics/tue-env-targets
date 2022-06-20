#! /usr/bin/env bash
set -e

if [ -f "$CUCR_BIN"/hero_dashboard.d/hero-dashboard ]
then
    cucr-install-debug "Removing old release folder"
    rm -rf "$CUCR_BIN"/hero_dashboard.d
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck disable=SC1090
"$DIR"/get-releases | source "$DIR"/process-releases

# Shortcuts
cucr-install-cp shortcuts/hero-dashboard.desktop ~/.local/share/applications/hero-dashboard.desktop
cucr-install-cp shortcuts/icons/hsr.png /usr/share/pixmaps/cucr/hsr.png

set +e
