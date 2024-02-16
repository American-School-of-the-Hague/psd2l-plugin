#!/usr/bin/env bash

## package a PowerQuery Plugin 

function abort {
    echo "$1"
    exit 1
}

function Help {
    echo "$(basename $0) Usage:
Packaging Script for PowerQuery Plugins    
    
    $ $(basename $0) path/to/package"
    exit 0
}

if [ $# -eq 0 ]; then
    Help
fi

if [ ! -d $1 ]
then
    abort "Directory \`$1\` does not appear to exist"
fi





TIME=$(date "+%Y%m%d_%H%M%S")
pushd $1 > /dev/null 2>&1
# VERSION=$(grep -Eo '^\s+version="(.*)"' ./plugin.xml | sed -ne 's/[^0-9]*\(\([0-9]\.\)\{0,5\}[0-9]\{0,8\}[^.]\).*".*/\1/p')
# VERSION=$(grep -Ei '^\s+version=".*"' ./plugin.xml | sed -E 's/^[[:space:]]{0,}version="(.*)"/\1/' )
VERSION=$(awk -F'"' '/version=/ && !/^</ {print $2}' ./plugin.xml |sed -E 's/.*version="([^"]+)".*/\1/')

echo "VERSION: $VERSION <<"

PACKAGENAME=$(basename $1)-V$VERSION-$TIME.zip

zip -X -r  ../$PACKAGENAME ./* -x "*.md" -x ".*"
echo ""
echo "CREATED PLUGIN: $PACKAGENAME"
popd > /dev/null 2>&1
