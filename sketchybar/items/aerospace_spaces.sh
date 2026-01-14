#!/usr/bin/env bash

# This script creates sketchybar items for each AeroSpace workspace.
# It is intended to be sourced from your sketchybarrc.

source "$HOME/.config/sketchybar/variables.sh"

# Ensure the AeroSpace CLI is available
if ! command -v "$AEROSPACE_CLI" &>/dev/null; then
  echo "AeroSpace CLI not found at $AEROSPACE_CLI. Please check your variables.sh file."
  exit 1
fi

# Add the event that will be triggered by AeroSpace on workspace changes
sketchybar --add event aerospace_workspace_change

# Hidden listener item keeps workspace list in sync
sketchybar --add item aerospace_sync left \
           --set aerospace_sync \
                 drawing=off \
                 updates=on \
                 script="$HOME/.config/sketchybar/plugins/aerospace_spaces_sync.sh" \
           --subscribe aerospace_sync aerospace_workspace_change

# Initial sync to populate workspace items
"$HOME/.config/sketchybar/plugins/aerospace_spaces_sync.sh"

# Add a yellow arrow after the aerospace bracket
sketchybar --add item aerospace_arrow left \
           --set aerospace_arrow \
                 icon="" \
                 icon.color=$HIGHLIGHT_COLOR \
                 icon.padding_left=$PADDINGS \
                 icon.padding_right=$PADDINGS \
                 label.drawing=off
