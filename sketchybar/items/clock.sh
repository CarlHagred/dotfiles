#!/usr/bin/env bash

sketchybar --add item clock right \
	--set clock \
	"${ISLAND_STYLE[@]}" \
	update_freq=1 \
	icon.font="$FONT:Bold:12.0" \
	icon.color="$ICON_DIM_COLOR" \
	icon.padding_left=14 \
	icon.padding_right=8 \
	label.color="$LABEL_COLOR" \
	label.padding_left=0 \
	label.padding_right=14 \
	popup.align=right \
	popup.y_offset=8 \
	popup.height=24 \
	popup.background.corner_radius="$POPUP_CORNER_RADIUS" \
	popup.background.shadow.drawing="$POPUP_SHADOW" \
	script="$PLUGIN_DIR/clock.sh" \
	--subscribe clock mouse.clicked mouse.exited.global system_woke mouse.entered mouse.exited

# Calendar popup: one item per line of `cal` output (filled by plugins/calendar_popup.sh)
CAL_ROW=("${POPUP_ROW_STYLE[@]}" icon.drawing=off label.font="$FONT:Bold:13.0" label.padding_left=12 label.padding_right=12
	# SketchyBar measures labels without their leading blanks, which hides week rows that
	# start with spaces; a fixed width (22 monospaced cells) avoids that
	label.width=176 label.align=left)

sketchybar --add item clock.cal.title popup.clock \
	--set clock.cal.title "${CAL_ROW[@]}" label.color="$ACCENT" \
	--add item clock.cal.head popup.clock \
	--set clock.cal.head "${CAL_ROW[@]}" label.color="$ICON_DIM_COLOR"

for i in 1 2 3 4 5 6; do
	sketchybar --add item "clock.cal.w$i" popup.clock \
		--set "clock.cal.w$i" "${CAL_ROW[@]}"
done
