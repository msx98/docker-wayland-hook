#!/bin/bash

set -e

install_or_update_conda() {
    local CONDA_DIR="$1"
    if [ ! -d "$CONDA_DIR" ]; then
        echo "Installing Miniconda..."
        wget -4 -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
        bash /tmp/miniconda.sh -b -p "$CONDA_DIR"
        rm /tmp/miniconda.sh
    else
        CONDA="$CONDA_DIR/bin/conda"
        echo "Accepting TOS"
        $CONDA tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
        $CONDA tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
        echo "Updating Miniconda..."
        $CONDA update
    fi
}

install_texlive() {
    local TEXLIVE_DIR="$1"
    TEXLIVE_INSTALLER_DIR="/home/user/tmp/install-tl"
    if [ ! -d "$TEXLIVE_DIR" ]; then
        echo "No TexLive installation found."
        mkdir -p ${TEXLIVE_INSTALLER_DIR}
        TAR_NAME="install-tl-unx.tar.gz"
        if [ ! -f "/home/user/tmp/${TAR_NAME}" ]; then
            echo "Downloading TexLive installer..."
            wget -4 -q https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz -O /home/user/tmp/${TAR_NAME}
            echo "Extracting TexLive installer..."
            tar -xzf /home/user/tmp/${TAR_NAME} -C ${TEXLIVE_INSTALLER_DIR} --strip-components=1
        fi
        cd ${TEXLIVE_INSTALLER_DIR}
        echo "Installing TexLive (this may take a while)..."
        perl install-tl --no-interaction --scheme=full --location=https://mirror.ctan.org/systems/texlive/tlnet \
            --texdir=${TEXLIVE_DIR} \
            --texmfvar=${TEXLIVE_DIR}/texmf-var \
            --texmfconfig=${TEXLIVE_DIR}/texmf-config
        echo "Cleaning up TexLive installer..."
        rm -rf /home/user/tmp
        echo "TexLive installation complete."
    else
        echo "TexLive already installed."
    fi
    if [ ! -e "/usr/local/texlive" ]; then
        echo "Creating symlink /usr/local/texlive -> ${TEXLIVE_DIR}..."
        ln -s "${TEXLIVE_DIR}" /usr/local/texlive
    fi
}

#install_or_update_conda "/home/user/.miniconda3"
install_texlive "/home/user/texlive"
