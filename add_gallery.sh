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

add_gallery()
{
    local gallery_folder=$1
    shift
    local input_folder=$1
    shift
    local gallery_name=$1
    shift

    local gallery_name_escaped="$(echo $gallery_name | sed -e 's/\s/_/g')"
    # remove all accent in path
    local gallery_path=$(echo "$gallery_folder/$gallery_name_escaped" | iconv -f UTF-8 -t ASCII//TRANSLIT)
    info "generate gallery at $gallery_path"

    fgallery -s --index '../' -c txt\
        --quality 80 --max-full 2000x2000 --max-thumb 300x300\
        "$input_folder" "$gallery_path" "$gallery_name"

    echo "$gallery_name" > "$gallery_path/gallery_name"
    info "generate index for $gallery_folder"
    $script_directory/generate_index.sh "$gallery_folder"

    info "index at: $gallery_folder/index.html"
    info "gallery at: $gallery_path"
}

[ $# -eq 2 ] || die "add_gallery: input_folder gallery_name"
add_gallery "$script_directory" "$@"
