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

generate_index()
{
    [ $# -ne 1 ] && die "generate_index: gallery_folder"

    local gallery_folder=$1
    shift

    pushd "$gallery_folder" > /dev/null

    local index_rst="index.rst"
    local index_html="index.html"

    cat << EOF > $index_rst
Mes galeries
============

EOF
    for gal in $(find . -mindepth 1 -maxdepth 1 -type d -not -path '*/\.*'\
                 | sort -n)
    do
        local gal_name="$(cat $gal/gallery_name)"
        size=$(du -hc "$gal"/imgs | tail -n 1 | cut -f 1)
        num_photos=$(ls "$gal"/imgs | wc -l)
        dl_link="https://minhaskamal.github.io/DownGit/#/home?url=$(cat GIT_URL)/tree/master/$gal/imgs"
        echo "- \`$gal_name <$gal/index.html>\`_ | \`zip ($num_photos photos, $size) <$dl_link>\`__" >> $index_rst
    done

    local total_size=$(du -h --exclude .git | tail -n 1 | cut -f 1)
    cat << EOF >> $index_rst

Taille totale: $total_size

Textes:

EOF

    for file in $(find . -mindepth 1 -maxdepth 1 -type f -path '*.rst' |\
                    grep -v index.rst | grep -v README.rst)
    do
        rst2html $file > $file.html
        echo "" >> $index_rst
        echo "- \`$file <$file.html>\`_" >> $index_rst
    done

    cat << EOF >> $index_rst

Mis à jour: $(date)

Git URL: $(cat GIT_URL)

EOF

    rst2html $index_rst > $index_html

    popd > /dev/null
}

generate_index "$script_directory"
