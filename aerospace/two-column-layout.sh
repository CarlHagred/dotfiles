#!/usr/bin/env bash

set -euo pipefail

AEROSPACE_BIN="${AEROSPACE_BIN:-$(command -v aerospace || true)}"
WINDOW_ID="${AEROSPACE_WINDOW_ID:-}"

fail() {
  printf 'aerospace two-column layout: %s\n' "$*" >&2
  exit 1
}

[ -n "$AEROSPACE_BIN" ] || fail "aerospace executable not found"
[ -n "$WINDOW_ID" ] || fail "AEROSPACE_WINDOW_ID is not set"

window_data() {
  "$AEROSPACE_BIN" list-windows --all \
    --format '%{window-id}|%{workspace}|%{window-parent-container-layout}|%{workspace-root-container-layout}'
}

window_info=""
for ((attempt = 0; attempt < 20; attempt++)); do
  window_info="$(window_data | awk -F '|' -v id="$WINDOW_ID" '$1 == id { print; exit }')"
  [ -n "$window_info" ] && break
  sleep 0.05
done

[ -n "$window_info" ] || fail "window $WINDOW_ID was not found"

IFS='|' read -r _ workspace _ _ <<<"$window_info"
lock_key="$(printf '%s' "$workspace" | cksum | awk '{ print $1 }')"
lock_dir="${TMPDIR:-/tmp}/aerospace-two-column-${lock_key}.lock"

locked=false
for ((attempt = 0; attempt < 100; attempt++)); do
  if mkdir "$lock_dir" 2>/dev/null; then
    locked=true
    break
  fi
  sleep 0.05
done

[ "$locked" = true ] || fail "timed out waiting for workspace $workspace layout lock"
trap 'rmdir "$lock_dir" 2>/dev/null || true' EXIT

windows="$(window_data | awk -F '|' -v ws="$workspace" '$2 == ws && $3 != "floating"')"
window_count="$(printf '%s\n' "$windows" | awk 'NF { count++ } END { print count + 0 }')"
[ "$window_count" -gt 0 ] || fail "workspace $workspace has no tiled windows"

anchor_id="$(
  printf '%s\n' "$windows" |
    awk -F '|' 'NR == 1 || $1 + 0 < min { min = $1 + 0; id = $1 } END { print id }'
)"

if [ "$window_count" -eq 1 ]; then
  exit 0
fi

layout_is_correct() {
  window_data |
    awk -F '|' -v ws="$workspace" -v anchor="$anchor_id" '
      $2 == ws && $3 != "floating" {
        count++
        if ($4 != "h_tiles") {
          invalid = 1
        } else if ($1 == anchor) {
          if ($3 != "h_tiles") invalid = 1
          anchor_count++
        } else if ($3 != "v_tiles") {
          invalid = 1
        }
      }
      END {
        exit !(count >= 3 && anchor_count == 1 && !invalid)
      }
    '
}

if [ "$window_count" -eq 2 ]; then
  anchor_info="$(window_data | awk -F '|' -v id="$anchor_id" '$1 == id { print; exit }')"
  [ -n "$anchor_info" ] || fail "anchor window $anchor_id disappeared while arranging workspace $workspace"
  IFS='|' read -r _ _ _ root_layout <<<"$anchor_info"

  if [ "$root_layout" != "h_tiles" ]; then
    "$AEROSPACE_BIN" layout --window-id "$anchor_id" tiles horizontal
  fi
  exit 0
fi

layout_is_correct && exit 0

# Usually AeroSpace inserts the new window directly into the existing right
# column. If it does not, move only that window instead of rebuilding the tree.
if [ "$WINDOW_ID" != "$anchor_id" ]; then
  "$AEROSPACE_BIN" move --window-id "$WINDOW_ID" right >/dev/null 2>&1 || true
  layout_is_correct && exit 0
fi

anchor_info="$(window_data | awk -F '|' -v id="$anchor_id" '$1 == id { print; exit }')"
[ -n "$anchor_info" ] || fail "anchor window $anchor_id disappeared while arranging workspace $workspace"
IFS='|' read -r _ _ _ root_layout <<<"$anchor_info"

if [ "$root_layout" != "h_tiles" ]; then
  "$AEROSPACE_BIN" layout --window-id "$anchor_id" tiles horizontal
fi

# Fallback for an unexpected tree. This path may visibly redraw the workspace,
# but normal window insertion returns through one of the fast paths above.
"$AEROSPACE_BIN" flatten-workspace-tree

for ((step = 0; step < window_count; step++)); do
  "$AEROSPACE_BIN" move --window-id "$anchor_id" right >/dev/null 2>&1 || break
done
for ((step = 0; step < window_count; step++)); do
  "$AEROSPACE_BIN" move --window-id "$anchor_id" left >/dev/null 2>&1 || break
done

layout_is_correct || fail "could not arrange workspace $workspace"
