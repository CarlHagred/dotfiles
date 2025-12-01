#!/usr/bin/env sh

# Color Palette
# Tokyonight Night
BLACK=0xff24283b
WHITE=0xffa9b1d6
MAGENTA=0xffbb9af7
BLUE=0xff7aa2f7
CYAN=0xff7dcfff
GREEN=0xff9ece6a
YELLOW=0xffe0af68
ORANGE=0xffff9e64
RED=0xfff7768e
BAR_COLOR=0x7f5db3
COMMENT=0xff565f89

# Tokyonight Day
# BLACK=0xffe9e9ed
# WHITE=0xff3760bf
# MAGENTA=0xff9854f1
# BLUE=0xff2e7de9
# CYAN=0xff007197
# GREEN=0xff587539
# YELLOW=0xff8c6c3e
# ORANGE=0xffb15c00
# RED=0xfff52a65
# BAR_COLOR=0xffe1e2e7

TRANSPARENT=0x00000000

# General bar colors
ICON_COLOR=$WHITE  # Color of all icons
LABEL_COLOR=$WHITE # Color of all labels

ITEM_DIR="$HOME/.config/sketchybar/items"
PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

FONT="MesloLGS Nerd Font Mono"

PADDINGS=3

POPUP_BORDER_WIDTH=2
POPUP_CORNER_RADIUS=11
POPUP_BACKGROUND_COLOR=$BLACK
POPUP_BORDER_COLOR=$COMMENT

CORNER_RADIUS=15
BORDER_WIDTH=2

SHADOW=on
WORKSPACE_COUNT=9

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
