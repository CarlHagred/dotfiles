#!/usr/bin/env bash

COLOR="$HIGHLIGHT_COLOR"

sketchybar --add item clock right \
--set clock update_freq=1 \
icon.padding_left=10 \
icon.color="$COLOR" \
icon="󰸗" \
icon.padding_right=3 \
label.color="$LABEL_COLOR" \
label.padding_right=10 \
background.height=26 \
background.corner_radius="$CORNER_RADIUS" \
background.padding_right=5 \
background.border_width="$BORDER_WIDTH" \
	background.border_color="$ITEM_BORDER_COLOR" \
	background.color="$ITEM_BG_COLOR" \
	background.shadow.drawing=off \
background.drawing=on \
popup.align=right \
popup.y_offset=6 \
popup.height=22 \
script="$PLUGIN_DIR/clock.sh" \
--subscribe clock mouse.clicked mouse.exited.global system_woke

# Calendar popup: one item per line of `cal` output (filled by plugins/calendar_popup.sh)
POPUP_ROW_DEFAULTS=(
	icon.drawing=off
	label.font="$FONT:Bold:13.0"
	label.color="$LABEL_COLOR"
	label.padding_left=12
	label.padding_right=12
	background.color="$TRANSPARENT"
	background.corner_radius=6
	background.height=20
	background.padding_left=6
	background.padding_right=6
	background.drawing=off
)

sketchybar --add item clock.cal.title popup.clock \
	--set clock.cal.title "${POPUP_ROW_DEFAULTS[@]}" label.color="$COLOR" \
	--add item clock.cal.head popup.clock \
	--set clock.cal.head "${POPUP_ROW_DEFAULTS[@]}" label.color="$ICON_DIM_COLOR"

for i in 1 2 3 4 5 6; do
	sketchybar --add item "clock.cal.w$i" popup.clock \
		--set "clock.cal.w$i" "${POPUP_ROW_DEFAULTS[@]}"
done
