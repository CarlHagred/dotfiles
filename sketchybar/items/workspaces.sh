#!/usr/bin/env bash
# Workspace pills (AeroSpace) and the divider between them and the front app.
# The pills are created and kept in sync by plugins/workspaces/workspaces.sh.

if ! command -v "$AEROSPACE_CLI" &>/dev/null; then
	echo "AeroSpace CLI not found at $AEROSPACE_CLI. Please check lib/common.sh."
	return 1 2>/dev/null || exit 1
fi

# Triggered by AeroSpace (exec-on-workspace-change in aerospace.toml)
sketchybar --add event aerospace_workspace_change

# Hidden listener item that keeps the workspace pills in sync
sketchybar --add item workspaces_sync left \
	--set workspaces_sync \
	drawing=off \
	updates=on \
	script="$PLUGIN_DIR/workspaces/workspaces.sh" \
	--subscribe workspaces_sync aerospace_workspace_change display_change

# Initial sync to create the pills
"$PLUGIN_DIR/workspaces/workspaces.sh"

sketchybar --add item workspace_divider left \
	--set workspace_divider \
	icon="│" \
	icon.color="$DIVIDER_COLOR" \
	icon.font="$FONT:Regular:12.0" \
	icon.padding_left=4 \
	icon.padding_right=4 \
	label.drawing=off \
	background.drawing=off
