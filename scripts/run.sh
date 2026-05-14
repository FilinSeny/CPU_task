#!/bin/bash

set -e

if [ $# -ne 1 ]; then
    echo "Usage:"
    echo "  ./run.sh tb_name"
    echo
    echo "Example:"
    echo "  ./run.sh tb_cpu"
    exit 1
fi

TB_NAME="$1"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$( dirname "$SCRIPT_DIR" )"

RTL_DIR="$ROOT_DIR"
TB_DIR="$ROOT_DIR/tb"
BUILD_DIR="$ROOT_DIR/build"

TB_FILE="$TB_DIR/${TB_NAME}.sv"

mkdir -p "$BUILD_DIR"

if [ ! -f "$TB_FILE" ]; then
    echo "ERROR: testbench not found:"
    echo "  $TB_FILE"
    exit 1
fi

echo "========================"
echo "Compile Verilog"
echo "========================"

iverilog \
    -g2012 \
    -o "$BUILD_DIR/${TB_NAME}.out" \
    "$RTL_DIR"/*.sv \
    "$TB_FILE"

echo
echo "========================"
echo "Run Simulation"
echo "========================"

vvp "$BUILD_DIR/${TB_NAME}.out"

VCD_FILE="$BUILD_DIR/${TB_NAME}.vcd"

if [ -f "$VCD_FILE" ]; then

    echo
    echo "========================"
    echo "Open GTKWave"
    echo "========================"

    gtkwave "$VCD_FILE"

else

    echo
    echo "WARNING:"
    echo "VCD file not found:"
    echo "  $VCD_FILE"

fi