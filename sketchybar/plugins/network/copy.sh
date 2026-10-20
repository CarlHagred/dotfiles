#!/usr/bin/env bash
# Click handler for the IP / router rows: copies the address and confirms for a moment.
#   copy.sh ip|router

row="network.$1"
OLD="$(sketchybar --query "$row" | jq -r '.label.value')"
VALUE="${OLD##* }"
printf '%s' "$VALUE" | pbcopy
sketchybar --set "$row" label="Copied $VALUE"
sleep 1.2
sketchybar --set "$row" label="$OLD"
