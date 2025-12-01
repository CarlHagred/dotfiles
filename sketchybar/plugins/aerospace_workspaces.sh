#!/usr/bin/env bash
# AeroSpace workspace plugin for SketchyBar
# - Displays workspaces 1..10 similar to yabai spaces design
# - Highlights focused workspace
# - Optionally dims/brightens occupied vs empty workspaces
# - Click to switch workspace using a configurable command
#
# Configuration is done via environment variables or variables.sh:
#   AEROSPACE_CLI                  - base CLI executable (default: "aerospace")
#   AEROSPACE_LIST_CMD             - lists all workspaces (one per line or space-separated numbers)
#                                   default: "$AEROSPACE_CLI list-workspaces"
#   AEROSPACE_FOCUSED_CMD          - prints the currently focused workspace index (e.g., "5")
#                                   default: "$AEROSPACE_CLI current-workspace"
#   AEROSPACE_OCCUPIED_CMD         - prints occupied workspaces (optional; format like list)
#                                   default: "$AEROSPACE_CLI occupied-workspaces"
#   AEROSPACE_SWITCH_CMD_TEMPLATE  - template to switch workspace when clicked; "{INDEX}" is replaced
#                                   default: "$AEROSPACE_CLI workspace {INDEX}"
#   WORKSPACE_COUNT                - number of workspaces to render (default: 10)
#
# Expected invocation:
#   - The script is used as a single plugin for items named like "workspace.<n>"
#   - It extracts the index from $NAME.
#
# Example SketchyBar setup (items/spaces.sh replacement):
#   for i in {1..10}; do
#     sketchybar --add item workspace.$i left \
#       --set workspace.$i \
#         label.drawing=off \
#         icon.padding_left=10 \
#         icon.padding_right=10 \
#         background.padding_left=-5 \
#         background.padding_right=-5 \
#         script="$PLUGIN_DIR/aerospace_workspaces.sh" \
#       --subscribe workspace.$i routine  # or use update_freq=1 if you prefer polling
#   done
#
# Notes:
#   - If your AeroSpace CLI uses different commands, set the env vars above in variables.sh or your shell.
#   - If AEROSPACE_OCCUPIED_CMD is unset or fails, the script will only highlight the focused workspace.


# Load shared variables (colors, FONT, etc.)
if [ -f "$HOME/.config/sketchybar/variables.sh" ]; then
  # shellcheck source=/dev/null
  source "$HOME/.config/sketchybar/variables.sh"
fi

# Defaults for configuration
AEROSPACE_CLI="${AEROSPACE_CLI:-aerospace}"
AEROSPACE_LIST_CMD="${AEROSPACE_LIST_CMD:-$AEROSPACE_CLI list-workspaces}"
AEROSPACE_FOCUSED_CMD="${AEROSPACE_FOCUSED_CMD:-$AEROSPACE_CLI current-workspace}"
AEROSPACE_OCCUPIED_CMD="${AEROSPACE_OCCUPIED_CMD:-$AEROSPACE_CLI occupied-workspaces}"
AEROSPACE_SWITCH_CMD_TEMPLATE="${AEROSPACE_SWITCH_CMD_TEMPLATE:-$AEROSPACE_CLI workspace {INDEX}}"
WORKSPACE_COUNT="${WORKSPACE_COUNT:-10}"

# Icons for 1..10 (you can replace with custom glyphs if desired)
SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

# Safe command runner: prints stdout or empty string on failure
run_cmd() {
  cmd="$1"
  # Use 'eval' to allow commands with arguments; ensure caller controls content
  # We redirect stderr to /dev/null to keep the bar quiet
  out="$(eval "$cmd" 2>/dev/null || true)"
  printf "%s" "$out"
}

# Normalize a list output into space-separated numbers (strip non-numeric)
normalize_list() {
  input="$1"
  # Replace newlines and commas with spaces, then filter numeric tokens
  echo "$input" | tr '\n,' '  ' | awk '
    {
      for (i = 1; i <= NF; i++) {
        if ($i ~ /^[0-9]+$/) {
          printf "%s ", $i
        }
      }
    }
  ' | sed 's/[[:space:]]\+$//'
}

# Extract index from item name "workspace.N"
# If not found, fall back to 1
extract_index_from_name() {
  n="$1"
  idx="$(echo "$n" | sed -n 's/.*\.\([0-9]\+\)$/\1/p')"
  if [ -z "$idx" ]; then
    idx="1"
  fi
  echo "$idx"
}

# Build click script by replacing {INDEX}
build_click_script() {
  idx="$1"
  tpl="$2"
  echo "$tpl" | sed "s/{INDEX}/$idx/g"
}

# Determine focus and occupancy
focused_raw="$(run_cmd "$AEROSPACE_FOCUSED_CMD")"
focused="$(echo "$focused_raw" | tr -cd '0-9')"

occupied_raw="$(run_cmd "$AEROSPACE_OCCUPIED_CMD")"
occupied_list="$(normalize_list "$occupied_raw")"

# Parse index for this item
SID="$(extract_index_from_name "$NAME")"

# Decide appearance:
# - Focused: red icon color (or $RED)
# - Occupied (non-focused): WHITE (or $WHITE)
# - Empty: COMMENT (dim)
ICON_FOCUSED_COLOR="${RED:-0xfff7768e}"
ICON_OCCUPIED_COLOR="${WHITE:-0xffa9b1d6}"
ICON_EMPTY_COLOR="${COMMENT:-0xff565f89}"

# Label is off in the item setup; we only set icon and colors here
ICON_VALUE="${SPACE_ICONS[$SID - 1]}"
if [ -z "$ICON_VALUE" ]; then
  ICON_VALUE="$SID"
fi

# Check if occupied_list contains SID
is_occupied="false"
for w in $occupied_list; do
  if [ "$w" = "$SID" ]; then
    is_occupied="true"
    break
  fi
done

# Focused?
is_focused="false"
if [ -n "$focused" ] && [ "$focused" = "$SID" ]; then
  is_focused="true"
fi

# Determine color based on focus/occupancy
if [ "$is_focused" = "true" ]; then
  ICON_COLOR="$ICON_FOCUSED_COLOR"
elif [ "$is_occupied" = "true" ]; then
  ICON_COLOR="$ICON_OCCUPIED_COLOR"
else
  ICON_COLOR="$ICON_EMPTY_COLOR"
fi

# Fallback when commands fail (no focus and no occupancy info)
if [ -z "$focused" ] && [ -z "$occupied_list" ]; then
  ICON_COLOR="${WHITE:-0xffa9b1d6}"
fi

# Click script
CLICK_SCRIPT="$(build_click_script "$SID" "$AEROSPACE_SWITCH_CMD_TEMPLATE")"

# Apply settings
sketchybar --animate tanh 5 --set "$NAME" \
  icon="$ICON_VALUE" \
  icon.drawing=on \
  icon.color="$ICON_COLOR" \
  click_script="$CLICK_SCRIPT"

# Optionally, update a bracket background named "workspaces" to match your design (if you created one):
# sketchybar --set workspaces background.drawing=on

# If you prefer to update all items at once (to avoid per-item calls), you can have a separate driver script
# that loops over 1..WORKSPACE_COUNT and calls sketchybar --set workspace.N ... directly. This plugin focuses on per-item updates.
