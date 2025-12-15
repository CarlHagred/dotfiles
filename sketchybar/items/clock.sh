#!/usr/bin/env bash

COLOR="$BLUE"

sketchybar --add item clock right \
--set clock update_freq=1 \
icon.padding_left=10 \
icon.color="$COLOR" \
icon="󰸗" \
icon.padding_right=3 \
label.color="$COLOR" \
label.padding_right=10 \
background.height=26 \
background.corner_radius="$CORNER_RADIUS" \
background.padding_right=5 \
background.border_width="$BORDER_WIDTH" \
background.border_color="$COLOR" \
background.color="$BAR_COLOR" \
background.drawing=on \
click_script="open -a Calendar" \
script="$PLUGIN_DIR/clock.sh"
