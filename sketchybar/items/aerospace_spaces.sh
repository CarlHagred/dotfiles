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

# Get the list of workspaces from AeroSpace
WORKSPACES=$("$AEROSPACE_CLI" list-workspaces --all)

for ws in $WORKSPACES; do
  sketchybar --add item space.$ws left \
    --set space.$ws \
    background.drawing=off \
    icon="$ws" \
    icon.color=0xffa9b1d6 \
    icon.padding_left=$((PADDINGS * 2)) \
    icon.padding_right=$((PADDINGS * 2)) \
    label.drawing=off \
    click_script="$AEROSPACE_CLI workspace $ws" \
    script="$HOME/.config/sketchybar/plugins/aerospace.sh $ws" \
    --subscribe space.$ws aerospace_workspace_change
done

# Add a bracket to group the workspace items
sketchybar --add bracket aerospace_bracket '/space\..*'/ \
           --set aerospace_bracket \
                 background.color=$TRANSPARENT \
                 background.corner_radius=11 \
                 background.height=26 \
                 background.border_width=2 \
                 background.border_color=0xfff7768e

# Add a yellow arrow after the aerospace bracket
sketchybar --add item aerospace_arrow left \
           --set aerospace_arrow \
                 icon="" \
                 icon.color=$YELLOW \
                 icon.padding_left=$PADDINGS \
                 icon.padding_right=$PADDINGS \
                 label.drawing=off
