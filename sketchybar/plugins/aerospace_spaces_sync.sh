#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"

if ! command -v "$AEROSPACE_CLI" &>/dev/null; then
  exit 0
fi

WORKSPACES=$("$AEROSPACE_CLI" list-workspaces --all 2>/dev/null)
if [ -z "$WORKSPACES" ]; then
  COUNT=${WORKSPACE_COUNT:-9}
  WORKSPACES=""
  for ((i = 1; i <= COUNT; i++)); do
    WORKSPACES="$WORKSPACES $i"
  done
  WORKSPACES=${WORKSPACES# }
fi
[ -z "$WORKSPACES" ] && exit 0

if [ -z "$FOCUSED" ]; then
  FOCUSED=$("$AEROSPACE_CLI" list-workspaces --focused 2>/dev/null)
fi
if [ -z "$FOCUSED" ]; then
  for ws in $WORKSPACES; do
    FOCUSED=$ws
    break
  done
fi

BRACKET_DIRTY=0

for ws in $WORKSPACES; do
  ITEM_CREATED=0
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
    ITEM_CREATED=1
    BRACKET_DIRTY=1
  fi

  if [ "$ITEM_CREATED" -eq 1 ]; then
    sketchybar --move "space.$ws" before aerospace_arrow
  fi

  if [ "$ws" = "$FOCUSED" ]; then
    COLOR=$SPACE_ACTIVE_COLOR
  else
    COLOR=$SPACE_INACTIVE_COLOR
  fi

  sketchybar --set "space.$ws" icon.color=$COLOR
done

# Rebuild bracket only when workspace items change
if [ "$BRACKET_DIRTY" -eq 1 ]; then
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
fi
