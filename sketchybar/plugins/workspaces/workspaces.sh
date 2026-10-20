#!/usr/bin/env bash
# Creates one pill per AeroSpace workspace and updates their state:
#   focused workspace -> accent fill, workspace visible on another monitor -> accent tint.
# Each pill is only drawn on the display of the monitor its workspace lives on.
# Runs on aerospace_workspace_change and display_change.

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"
source "$LIB_DIR/displays.sh"

command -v "$AEROSPACE_CLI" &>/dev/null || exit 0

# "<workspace> <NSScreen index of its monitor>" per line
WORKSPACES=$("$AEROSPACE_CLI" list-workspaces --all --format '%{workspace} %{monitor-appkit-nsscreen-screens-id}' 2>/dev/null)
if [ -z "$WORKSPACES" ]; then
	WORKSPACES=""
	for ((i = 1; i <= WORKSPACE_COUNT; i++)); do
		WORKSPACES="$WORKSPACES$i 0"$'\n'
	done
fi

FOCUSED="${FOCUSED:-$("$AEROSPACE_CLI" list-workspaces --focused 2>/dev/null)}"
VISIBLE=$("$AEROSPACE_CLI" list-workspaces --monitor all --visible 2>/dev/null)
EXISTING=$(sketchybar --query bar | jq -r '.items[]')

# SketchyBar display id for every monitor that hosts a workspace ("<screen> <display>" per line)
SCREEN_MAP=""
for screen in $(awk '$2 > 0 {print $2}' <<<"$WORKSPACES" | sort -u); do
	SCREEN_MAP="$SCREEN_MAP$screen $(display_for_screen "$screen")"$'\n'
done

ITEMS_ADDED=0
while read -r ws screen; do
	[ -z "$ws" ] && continue

	if ! grep -qx "space.$ws" <<<"$EXISTING"; then
		sketchybar --add item "space.$ws" left \
			--set "space.$ws" \
			background.drawing=on \
			background.color="$TRANSPARENT" \
			background.height="$PILL_HEIGHT" \
			background.corner_radius="$PILL_RADIUS" \
			background.padding_left=2 \
			background.padding_right=2 \
			icon="$ws" \
			icon.color="$SPACE_INACTIVE_COLOR" \
			icon.padding_left=9 \
			icon.padding_right=9 \
			label.drawing=off \
			click_script="$AEROSPACE_CLI workspace $ws" \
			script="$PLUGIN_DIR/workspaces/hover.sh" \
			--subscribe "space.$ws" mouse.entered mouse.exited
		sketchybar --move "space.$ws" before workspace_divider 2>/dev/null
		ITEMS_ADDED=1
	fi

	display_id=0
	if [ "${screen:-0}" -gt 0 ]; then
		display_id="$(awk -v s="$screen" '$1 == s {print $2}' <<<"$SCREEN_MAP")"
		display_id="${display_id:-0}"
	fi

	if [ "$ws" = "$FOCUSED" ]; then
		icon_color="$SPACE_ACTIVE_COLOR"
		pill_color="$ACCENT"
	elif grep -qx "$ws" <<<"$VISIBLE"; then
		icon_color="$ACCENT"
		pill_color="$ACCENT_TINT"
	else
		icon_color="$SPACE_INACTIVE_COLOR"
		pill_color="$TRANSPARENT"
	fi
	sketchybar --animate tanh 10 --set "space.$ws" display="$display_id" icon.color="$icon_color" background.color="$pill_color"
done <<<"$WORKSPACES"

# Rebuild the left island only when workspace items changed
[ "$ITEMS_ADDED" -eq 1 ] && "$PLUGIN_DIR/workspaces/left_island.sh"

# A monitor was plugged in or removed: keep the status island on the main display
[ "$SENDER" = "display_change" ] && apply_status_display
exit 0
