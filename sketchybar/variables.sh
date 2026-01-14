#!/usr/bin/env sh

# macOS-inspired frosted palette
GLASS_BLACK=0xff1c1c1e
GLASS_DARK=0xff2c2c2e
GLASS_LIGHT=0xfff5f5f7
ACCENT_BLUE=0xff5ac8fa
ACCENT_MINT=0xff34c759
ACCENT_YELLOW=0xffffd60a
ACCENT_PINK=0xffff9f9a
ACCENT_PURPLE=0xffbf5af2
GLASS_STROKE=0x55ffffff
GLASS_FILL=0x33ffffff

BLACK=$GLASS_BLACK
WHITE=$GLASS_LIGHT
MAGENTA=$ACCENT_PURPLE
BLUE=$ACCENT_BLUE
CYAN=0xff64d2ff
GREEN=$ACCENT_MINT
YELLOW=$ACCENT_YELLOW
ORANGE=0xffffa733
RED=0xffff453a
BAR_COLOR=$TRANSPARENT
COMMENT=0x88f5f5f7

TRANSPARENT=0x00000000

# General bar colors
ICON_COLOR=$WHITE      # Color of all icons
LABEL_COLOR=$WHITE     # Color of all labels
ICON_DIM_COLOR=0x99f5f5f7
ITEM_BG_COLOR=$GLASS_FILL
ITEM_ACTIVE_BG=0x55ffffff
ITEM_BORDER_COLOR=0x22ffffff
HIGHLIGHT_COLOR=$ACCENT_BLUE
SECONDARY_HIGHLIGHT=$ACCENT_PURPLE

ITEM_DIR="$HOME/.config/sketchybar/items"
PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

FONT="MesloLGS Nerd Font Mono"

PADDINGS=6

POPUP_BORDER_WIDTH=1
POPUP_CORNER_RADIUS=12
POPUP_BACKGROUND_COLOR=0xee1c1c1e
POPUP_BORDER_COLOR=$ITEM_BORDER_COLOR

CORNER_RADIUS=14
BORDER_WIDTH=1

SHADOW=off
WORKSPACE_COUNT=5

SPACE_ACTIVE_COLOR=$HIGHLIGHT_COLOR
SPACE_INACTIVE_COLOR=$ICON_DIM_COLOR

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
