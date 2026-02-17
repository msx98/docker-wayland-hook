#!/bin/bash

[ ! -z "$USER" ] || export USER=$(getent passwd $UID | cut -d: -f1)
[ ! -z "$HOME" ] || export HOME=$(getent passwd $UID | cut -d: -f6)
[ ! -z "$XDG_RUNTIME_DIR" ] || export XDG_RUNTIME_DIR=/run/user/$UID
export MOZ_ENABLE_WAYLAND=1
export XCURSOR_THEME=Adwaita
export XCURSOR_SIZE=48
export GDK_SCALE=2
export GDK_BACKEND=wayland
export XCURSOR_PATH=/usr/share/icons
$@

