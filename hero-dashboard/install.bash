#! /usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Move release folder to new location
if [[ -d "$TUE_BIN/hero_dashboard" ]]
then
    mv "$TUE_BIN/hero_dashboard" "$TUE_BIN/hero_dashboard.d"

    # Remove old broken link
    if [[ -L "$TUE_BIN/hero-dashboard" ]] && [[ ! -f "$TUE_BIN/hero-dashboard" ]]
    then
        rm "$TUE_BIN/hero-dashboard"
    fi
    # Create new link if available
    if [[ -f "$TUE_BIN/hero_dashboard.d/hero-dashboard" ]] && [[ ! -f "$TUE_BIN/hero_dashboard" ]]
    then
        ln -sf "$TUE_BIN/hero_dashboard.d/hero-dashboard" "$TUE_BIN/hero_dashboard"
    fi
fi

# Remove old localhost files for testing
if [[ -d "$TUE_BIN/hero_dashboard_localhost" ]]
then
    rm -rf "$TUE_BIN/hero_dashboard_localhost"
fi

# Remove old broken link
if [[ -L "$TUE_BIN/hero-dashboard-localhost" ]] && [[ ! -f "$TUE_BIN/hero-dashboard-localhost" ]]
then
    rm "$TUE_BIN/hero-dashboard-localhost"
fi

"$DIR"/get-releases linux-x64 | "$DIR"/process-releases
