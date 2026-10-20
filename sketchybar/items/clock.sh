#!/usr/bin/env bash
# Clock island: date (dim) in the icon slot, time in the label. Click opens the calendar popup.

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
	"${POPUP_ISLAND_STYLE[@]}" \
	script="$PLUGIN_DIR/clock/clock.sh" \
	--subscribe clock mouse.clicked system_woke mouse.entered mouse.exited

# Calendar popup, filled by plugins/clock/popup.sh and plugins/clock/events.sh.
CAL_WIDTH=200
# SketchyBar measures labels without their leading blanks, which hides week rows that
# start with spaces, so the calendar rows have a fixed width.
CAL_ROW=("${POPUP_ROW_STYLE[@]}"
	icon.drawing=off
	label.padding_left=12
	label.padding_right=12
	label.width="$CAL_WIDTH"
	label.align=center
	script="$PLUGIN_DIR/clock/nav.sh")
# Grid rows are left aligned (centering mis-measures rows that start with blanks) and
# indented by half of the spare width instead.
CAL_GRID=("${CAL_ROW[@]}" label.align=left label.padding_left=24 label.padding_right=0)

sketchybar \
	--add item clock.cal.title popup.clock \
	--set clock.cal.title "${CAL_ROW[@]}" label.color="$ACCENT" \
	--subscribe clock.cal.title mouse.clicked mouse.scrolled \
	\
	--add item clock.cal.today popup.clock \
	--set clock.cal.today "${CAL_ROW[@]}" label="↩ Today" label.color="$ICON_DIM_COLOR" drawing=off \
	--subscribe clock.cal.today mouse.clicked mouse.scrolled \
	\
	--add item clock.cal.head popup.clock \
	--set clock.cal.head "${CAL_GRID[@]}" label.color="$ICON_DIM_COLOR" \
	--subscribe clock.cal.head mouse.scrolled

for i in 1 2 3 4 5 6; do
	sketchybar --add item "clock.cal.w$i" popup.clock \
		--set "clock.cal.w$i" "${CAL_GRID[@]}" \
		--subscribe "clock.cal.w$i" mouse.scrolled
done

# Upcoming events
sketchybar \
	--add item clock.ev.sep popup.clock \
	--set clock.ev.sep "${POPUP_RULE_STYLE[@]}" width="$CAL_WIDTH" \
	--add item clock.ev.hdr popup.clock \
	--set clock.ev.hdr "${POPUP_ROW_STYLE[@]}" \
	icon.drawing=off \
	label="UPCOMING" \
	label.color="$ICON_DIM_COLOR" \
	label.font="$FONT:Bold:10.5" \
	label.padding_left=14 \
	click_script="open -a Calendar"

for i in 1 2 3 4 5; do
	sketchybar --add item "clock.ev.$i" popup.clock \
		--set "clock.ev.$i" "${POPUP_ROW_STYLE[@]}" \
		icon.drawing=off \
		drawing=off \
		label.width="$CAL_WIDTH" \
		label.align=left \
		label.max_chars=25 \
		click_script="open -a Calendar"
done
