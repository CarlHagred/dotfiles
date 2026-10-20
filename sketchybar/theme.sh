# Design tokens: colours, metrics and fonts. Sourced through lib/common.sh.
# Colours are 0xAARRGGBB.

TRANSPARENT=0x00000000

# Surfaces
ISLAND_BG=0xd91c1c1e
ISLAND_BORDER=0x1fffffff
ISLAND_BORDER_HOVER=0x40ffffff
HOVER_BG=0x1fffffff
DIVIDER_COLOR=0x26ffffff
INK=0xff101014 # Dark text on accent fills

# Text
WHITE=0xfff5f5f7
LABEL_COLOR=$WHITE
ICON_COLOR=0xd9f5f5f7
ICON_DIM_COLOR=0x8cf5f5f7

# One accent, plus semantic colours
ACCENT=0xff5ac8fa
ACCENT_TINT=0x335ac8fa # Translucent accent for highlighted rows
GREEN=0xff34c759
ORANGE=0xffffa733
RED=0xffff453a

# Metrics
BAR_HEIGHT=36
ITEM_HEIGHT=28 # Island height
PILL_HEIGHT=22 # Pills inside an island
CORNER_RADIUS=14
PILL_RADIUS=11
BORDER_WIDTH=1
GAP=8 # Space between islands
PADDINGS=6

# Popups
POPUP_BACKGROUND_COLOR=0xf21c1c1e
POPUP_BORDER_COLOR=$ISLAND_BORDER
POPUP_BORDER_WIDTH=1
POPUP_CORNER_RADIUS=14
POPUP_SHADOW=on

# Workspace pills
SPACE_ACTIVE_COLOR=$INK
SPACE_INACTIVE_COLOR=$ICON_DIM_COLOR

# Typography and bar shadow
FONT="MesloLGS Nerd Font Mono"
SHADOW=off
