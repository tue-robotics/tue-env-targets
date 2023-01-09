#! /usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck disable=SC1091
"$DIR"/get-releases | source "$DIR"/process-releases

# Shortcuts
tue-install-cp shortcuts/hero-dashboard.desktop ~/.local/share/applications/hero-dashboard.desktop
tue-install-cp shortcuts/icons/hsr.png /usr/share/pixmaps/tue/hsr.png

set +e
