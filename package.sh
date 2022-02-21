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
PACKAGENAME=$(basename $1)-$TIME.zip
pushd $1
zip -X -r ../$PACKAGENAME ./*