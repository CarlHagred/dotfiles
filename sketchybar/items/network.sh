#!/usr/bin/env bash

COLOR="$SECONDARY_HIGHLIGHT"

sketchybar --add item network right \
  --set network \
  update_freq=10 \
  icon.color="$COLOR" \
  icon.padding_left=18 \
  label.color="$LABEL_COLOR" \
  label.padding_right=10 \
  background.height=26 \
  background.corner_radius="$CORNER_RADIUS" \
  background.border_width="$BORDER_WIDTH" \
  background.border_color="$ITEM_BORDER_COLOR" \
  background.color="$ITEM_BG_COLOR" \
  background.shadow.drawing=off \
  background.drawing=on \
  click_script="open /System/Library/PreferencePanes/Network.prefPane" \
  script="$PLUGIN_DIR/network.sh"
