#!/usr/bin/env bash

COLOR="$MAGENTA"

sketchybar --add item network right \
  --set network \
  update_freq=10 \
  icon.color="$COLOR" \
  icon.padding_left=18 \
  label.color="$COLOR" \
  label.padding_right=10 \
  background.height=26 \
  background.corner_radius="$CORNER_RADIUS" \
  background.border_width="$BORDER_WIDTH" \
  background.border_color="$COLOR" \
  background.color="$BAR_COLOR" \
  background.drawing=on \
  click_script="open /System/Library/PreferencePanes/Network.prefPane" \
  script="$PLUGIN_DIR/network.sh"
