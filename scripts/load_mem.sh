#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage:"
    echo "  ./load_mem.sh filename.mem"
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$( dirname "$SCRIPT_DIR" )"

SRC_FILE="$ROOT_DIR/data/$1"
DST_FILE="$ROOT_DIR/data/program.mem"

if [ ! -f "$SRC_FILE" ]; then
    echo "ERROR: file not found:"
    echo "  $SRC_FILE"
    exit 1
fi

cp "$SRC_FILE" "$DST_FILE"

echo "Copied:"
echo "  $SRC_FILE"
echo "to:"
echo "  $DST_FILE"