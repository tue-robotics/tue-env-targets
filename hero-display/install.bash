#! /usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

releases=$("$DIR"/get-releases)
# shellcheck disable=SC1091
source "$DIR"/process-releases "${releases}"

set +e
