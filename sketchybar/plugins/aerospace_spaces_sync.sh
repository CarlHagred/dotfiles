#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"

if ! command -v "$AEROSPACE_CLI" &>/dev/null; then
  exit 0
fi

WORKSPACES=$("$AEROSPACE_CLI" list-workspaces --all 2>/dev/null)
[ -z "$WORKSPACES" ] && exit 0

if [ -z "$FOCUSED" ]; then
  FOCUSED=$("$AEROSPACE_CLI" list-workspaces --focused 2>/dev/null)
fi

for ws in $WORKSPACES; do
  if ! sketchybar --query "space.$ws" >/dev/null 2>&1; then
    sketchybar --add item "space.$ws" left \
      --set "space.$ws" \
        background.drawing=off \
        icon="$ws" \
        icon.color=$SPACE_INACTIVE_COLOR \
        icon.padding_left=$((PADDINGS * 2)) \
        icon.padding_right=$((PADDINGS * 2)) \
        label.drawing=off \
        associated_bracket=aerospace_bracket \
        click_script="$AEROSPACE_CLI workspace $ws"
  else
    sketchybar --set "space.$ws" associated_bracket=aerospace_bracket
  fi

  # Ensure workspace chips stay grouped before the arrow item
  sketchybar --move "space.$ws" before aerospace_arrow

  if [ "$ws" = "$FOCUSED" ]; then
    COLOR=$SPACE_ACTIVE_COLOR
  else
    COLOR=$SPACE_INACTIVE_COLOR
  fi

  sketchybar --set "space.$ws" icon.color=$COLOR
done

# Rebuild bracket to include all workspace items
BRACKET_ITEMS=""
for ws in $WORKSPACES; do
  BRACKET_ITEMS="$BRACKET_ITEMS space.$ws"
done

if [ -n "$BRACKET_ITEMS" ]; then
  sketchybar --remove aerospace_bracket >/dev/null 2>&1
  sketchybar --add bracket aerospace_bracket $BRACKET_ITEMS
  sketchybar --set aerospace_bracket \
    background.color=$ITEM_BG_COLOR \
    background.corner_radius=11 \
    background.height=26 \
    background.border_width=$BORDER_WIDTH \
    background.border_color=$ITEM_BORDER_COLOR \
    background.shadow.drawing=off \
    y_offset=0
fi
