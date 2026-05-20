#!/bin/bash

set -euo pipefail
shopt -s nullglob

if [ $# -eq 0 ]; then
    echo "No args provided!"
    exit 1
fi

git $1 origin main:work s