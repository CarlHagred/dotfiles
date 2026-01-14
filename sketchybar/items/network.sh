#!/usr/bin/env bash

COLOR="$SECONDARY_HIGHLIGHT"

ICON_ITEM="network"
LABEL_ITEM="${ICON_ITEM}_label"

sketchybar --add item "$ICON_ITEM" right \
  --set "$ICON_ITEM" \
  update_freq=10 \
  icon.color="$COLOR" \
  icon.padding_left=10 \
  icon.padding_right=10 \
  label.drawing=off \
  background.height=26 \
  background.corner_radius="$CORNER_RADIUS" \
  background.border_width="$BORDER_WIDTH" \
  background.border_color="$ITEM_BORDER_COLOR" \
  background.color="$ITEM_BG_COLOR" \
  background.shadow.drawing=off \
  background.drawing=on \
  click_script="open /System/Library/PreferencePanes/Network.prefPane" \
  script="$PLUGIN_DIR/network.sh"

sketchybar --add item "$LABEL_ITEM" right \
  --set "$LABEL_ITEM" \
  icon.drawing=off \
  label.color="$LABEL_COLOR" \
  label.padding_left=8 \
  label.padding_right=10 \
  background.drawing=off \
  click_script="open /System/Library/PreferencePanes/Network.prefPane"
