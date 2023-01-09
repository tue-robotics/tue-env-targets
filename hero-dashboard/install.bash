#! /usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

releases=$("$DIR"/get-releases)
# shellcheck disable=SC1091
source "$DIR"/process-releases "${releases}"

# Shortcuts
tue-install-cp shortcuts/hero-dashboard.desktop ~/.local/share/applications/hero-dashboard.desktop
tue-install-cp shortcuts/icons/hsr.png /usr/share/pixmaps/tue/hsr.png

set +e
