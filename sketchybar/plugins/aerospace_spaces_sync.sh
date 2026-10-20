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
        background.drawing=on \
        background.color=$TRANSPARENT \
        background.height=$PILL_HEIGHT \
        background.corner_radius=$PILL_RADIUS \
        background.padding_left=2 \
        background.padding_right=2 \
        icon="$ws" \
        icon.color=$SPACE_INACTIVE_COLOR \
        icon.padding_left=9 \
        icon.padding_right=9 \
        label.drawing=off \
        click_script="$AEROSPACE_CLI workspace $ws" \
        script="$PLUGIN_DIR/space_hover.sh" \
      --subscribe "space.$ws" mouse.entered mouse.exited
    ITEM_CREATED=1
    BRACKET_DIRTY=1
  fi

  if [ "$ITEM_CREATED" -eq 1 ]; then
    sketchybar --move "space.$ws" before aerospace_arrow
  fi

  if [ "$ws" = "$FOCUSED" ]; then
    sketchybar --animate tanh 10 --set "space.$ws" icon.color=$SPACE_ACTIVE_COLOR background.color=$ACCENT
  else
    sketchybar --animate tanh 10 --set "space.$ws" icon.color=$SPACE_INACTIVE_COLOR background.color=$TRANSPARENT
  fi
done

# Rebuild the left island only when workspace items change
if [ "$BRACKET_DIRTY" -eq 1 ]; then
  "$HOME/.config/sketchybar/plugins/left_island.sh"
fi
