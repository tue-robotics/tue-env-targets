#! /usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck disable=SC1090
"$DIR"/get-releases | source "$DIR"/process-releases

set +e
