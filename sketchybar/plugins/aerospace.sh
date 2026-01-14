#!/usr/bin/env bash

# This script is called when the AeroSpace workspace changes.
# It highlights the focused workspace in sketchybar.

source "$HOME/.config/sketchybar/variables.sh"

# Ensure the AeroSpace CLI is available
if ! command -v "$AEROSPACE_CLI" &> /dev/null; then
  exit 1
fi

WORKSPACE_ID=$1

# The focused workspace is passed in the FOCUSED environment variable
if [ -z "$FOCUSED" ]; then
  # Fallback to querying aerospace directly if the env var is not set
  FOCUSED=$("$AEROSPACE_CLI" list-workspaces --focused)
fi

# Define colors
FOCUSED_COLOR_FOR_NUMBER=$SPACE_ACTIVE_COLOR
DEFAULT_COLOR_FOR_NUMBER=$SPACE_INACTIVE_COLOR

if [ "$WORKSPACE_ID" = "$FOCUSED" ]; then
  # This is the focused workspace
  sketchybar --set space.$WORKSPACE_ID \
             icon.color=$FOCUSED_COLOR_FOR_NUMBER
else
  # This is not the focused workspace
  sketchybar --set space.$WORKSPACE_ID \
             icon.color=$DEFAULT_COLOR_FOR_NUMBER
fi
