#!/bin/bash

set -e

# Install Miniconda into home
MINICONDA_DIR="/home/user/.miniconda3"
if [ ! -d "$MINICONDA_DIR" ]; then
    echo "Installing Miniconda..."
    wget -4 -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
    bash /tmp/miniconda.sh -b -p "$MINICONDA_DIR"
    rm /tmp/miniconda.sh
else
    CONDA="$MINICONDA_DIR/bin/conda"
    echo "Accepting TOS"
    #source "$MINICONDA_DIR/bin/activate"
    $CONDA tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
    $CONDA tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
    echo "Updating Miniconda..."
    $CONDA update
fi
