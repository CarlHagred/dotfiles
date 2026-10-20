#!/usr/bin/env bash
# Hover tint for workspace pills; the focused workspace keeps its accent fill.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

[ "${NAME#space.}" = "$("$AEROSPACE_CLI" list-workspaces --focused 2>/dev/null)" ] && exit 0

source "$LIB_DIR/hover.sh"
