#!/usr/bin/env bash

# Hover tint for workspace pills; the focused workspace keeps its accent fill.

source "$HOME/.config/sketchybar/variables.sh"

WS="${NAME#space.}"
FOCUSED=$("$AEROSPACE_CLI" list-workspaces --focused 2>/dev/null)
[ "$WS" = "$FOCUSED" ] && exit 0

source "$PLUGIN_DIR/hover.sh"
