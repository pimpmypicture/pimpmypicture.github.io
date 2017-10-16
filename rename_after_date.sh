#!/bin/bash
set -euo pipefail

script_directory=$(dirname $(readlink -f $0))

die()
{
    error "$@"
    exit 1
}

error()
{
    echo "ERROR: $@"
}

info()
{
    echo "INFO: $@"
}

rename_after_date()
{
    [ $# -ne 1 ] && die "rename_after_date: pictures_folder"

    local pictures_folder=$1
    shift

    exiftool '-filename<${datetimeoriginal}' -d "%Y-%m-%d_%H.%M.%S%%-c.%%e" "$pictures_folder"
}

rename_after_date "$@"
