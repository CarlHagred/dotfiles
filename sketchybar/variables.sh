#!/usr/bin/env sh

TRANSPARENT=0x00000000

# Neutral glass surfaces
INK=0xff101014               # Dark text on accent fills
ISLAND_BG=0xd91c1c1e         # Island / popup surface
ISLAND_BORDER=0x1fffffff     # Hairline border
HOVER_BG=0x1fffffff          # Hover tint on pills
DIVIDER_COLOR=0x26ffffff

# Text
WHITE=0xfff5f5f7
LABEL_COLOR=$WHITE
ICON_COLOR=0xd9f5f5f7
ICON_DIM_COLOR=0x8cf5f5f7
COMMENT=0x88f5f5f7

# One accent, plus semantic colours
ACCENT=0xff5ac8fa
ACCENT_TINT=0x335ac8fa       # Translucent accent for highlighted rows
GREEN=0xff34c759
YELLOW=0xffffd60a
ORANGE=0xffffa733
RED=0xffff453a
BLACK=0xff1c1c1e

# Legacy names used across items and plugins
BAR_COLOR=$TRANSPARENT
ITEM_BG_COLOR=$ISLAND_BG
ITEM_ACTIVE_BG=$ACCENT_TINT
ITEM_BORDER_COLOR=$ISLAND_BORDER
HIGHLIGHT_COLOR=$ACCENT
SECONDARY_HIGHLIGHT=$ACCENT

# Metrics
BAR_HEIGHT=36
ITEM_HEIGHT=28               # Island height
PILL_HEIGHT=22               # Pills inside an island
CORNER_RADIUS=14             # Island radius
PILL_RADIUS=11
BORDER_WIDTH=1
GAP=8                        # Space between islands
PADDINGS=6

POPUP_BACKGROUND_COLOR=0xf21c1c1e
POPUP_BORDER_COLOR=$ISLAND_BORDER
POPUP_BORDER_WIDTH=1
POPUP_CORNER_RADIUS=14

FONT="MesloLGS Nerd Font Mono"

SHADOW=off
POPUP_SHADOW=on
WORKSPACE_COUNT=5

SPACE_ACTIVE_COLOR=$INK
SPACE_INACTIVE_COLOR=$ICON_DIM_COLOR

ITEM_DIR="$HOME/.config/sketchybar/items"
PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

AEROSPACE_CLI="/opt/homebrew/bin/aerospace"  # or "aerospace" if on PATH
CONFIG_DIR="$HOME/.config/sketchybar"

# Returns workspaces (space/newline separated; numbers or names)
AEROSPACE_LIST_CMD="$AEROSPACE_CLI list-workspaces"        # replace with your actual command

# Returns the current workspace (number or name)
AEROSPACE_FOCUSED_CMD="$AEROSPACE_CLI current-workspace"   # replace with your actual command

# Optional: returns occupied workspaces (same format as list)
AEROSPACE_OCCUPIED_CMD="$AEROSPACE_CLI occupied-workspaces"  # set to "" if unsupported

# Click switches workspace; {INDEX} is substituted
AEROSPACE_SWITCH_CMD_TEMPLATE="$AEROSPACE_CLI workspace {INDEX}"

# If your focused/occupied outputs are NAMES, provide a name→index mapping (or rely on position)
AEROSPACE_NAME_TO_INDEX_CMD=""
# Show numbers or names in the icons
WORKSPACE_ICON_MODE="number"  # or "name"
