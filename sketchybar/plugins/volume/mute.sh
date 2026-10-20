#!/usr/bin/env bash
# Mute row click: toggle mute, then refresh the volume item.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

"$SB_HELPER" toggle-mute
NAME=volume SENDER=forced "$PLUGIN_DIR/volume/volume.sh"
