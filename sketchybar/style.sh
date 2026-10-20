#!/usr/bin/env bash

# Shared style building blocks. Sourced from sketchybarrc after variables.sh.

# A standalone island: one item drawn as a rounded glass pill
ISLAND_STYLE=(
	background.drawing=on
	background.color="$ISLAND_BG"
	background.border_color="$ISLAND_BORDER"
	background.border_width="$BORDER_WIDTH"
	background.corner_radius="$CORNER_RADIUS"
	background.height="$ITEM_HEIGHT"
	background.shadow.drawing=off
	background.padding_left=0
	background.padding_right=0
)

# The shell drawn by a bracket around several items
BRACKET_STYLE=(
	background.drawing=on
	background.color="$ISLAND_BG"
	background.border_color="$ISLAND_BORDER"
	background.border_width="$BORDER_WIDTH"
	background.corner_radius="$CORNER_RADIUS"
	background.height="$ITEM_HEIGHT"
	background.shadow.drawing=off
)

# An item living inside a bracket: hover pill, transparent until hovered
PILL_STYLE=(
	background.drawing=on
	background.color="$TRANSPARENT"
	background.corner_radius="$PILL_RADIUS"
	background.height="$PILL_HEIGHT"
	background.border_width=0
	background.padding_left=3
	background.padding_right=3
	icon.padding_left=9
	icon.padding_right=5
	label.padding_left=0
	label.padding_right=9
)

# Thin vertical separator between pills
DIVIDER_STYLE=(
	icon.drawing=off
	label.drawing=off
	width=1
	background.drawing=on
	background.color="$DIVIDER_COLOR"
	background.height=14
	background.corner_radius=1
	background.padding_left=2
	background.padding_right=2
)

# Invisible spacer between islands
spacer() {
	sketchybar --add item "gap.$1" "$2" --set "gap.$1" width="$GAP" icon.drawing=off label.drawing=off background.drawing=off
}

# Popup row (used by calendar and volume popups)
POPUP_ROW_STYLE=(
	icon.font="$FONT:Bold:13.5"
	icon.color="$ACCENT"
	icon.padding_left=12
	icon.padding_right=4
	label.font="$FONT:Bold:13.0"
	label.color="$LABEL_COLOR"
	label.padding_left=4
	label.padding_right=12
	background.color="$TRANSPARENT"
	background.corner_radius=8
	background.height=24
	background.padding_left=6
	background.padding_right=6
	background.drawing=off
)
