#!/usr/bin/env bash
# Click handler for a device row in the volume popup: select.sh <row number>
#   out -> switch the output (and system sound output)    in -> switch the input
#   bt  -> connect the paired Bluetooth device, then switch the output to it

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"

CACHE="$STATE_DIR/audio_devices"

IDX="$1"
IFS='|' read -r kind id name < <(sed -n "${IDX}p" "$CACHE")
[ -z "$kind" ] && exit 0
ROW="volume.dev.$IDX"

switch_to() {
	SwitchAudioSource -s "$1" -t output >/dev/null
	SwitchAudioSource -s "$1" -t system >/dev/null 2>&1
}

finish() {
	"$PLUGIN_DIR/volume/devices.sh"
	NAME=volume SENDER=forced "$PLUGIN_DIR/volume/volume.sh"
}

case "$kind" in
hdr) exit 0 ;;
out)
	switch_to "$id"
	finish
	exit 0
	;;
in)
	SwitchAudioSource -s "$id" -t input >/dev/null
	finish
	exit 0
	;;
esac

# Bluetooth device that is paired but not connected yet
before="$(SwitchAudioSource -a -t output 2>/dev/null)"
sketchybar --set "$ROW" icon="󰑓" label="Connecting…"

if ! blueutil --connect "$id" >/dev/null 2>&1; then
	sketchybar --set "$ROW" icon="󰀦" icon.color="$RED" label="Could not connect"
	sleep 2
	finish
	exit 0
fi

# Output devices appear a moment after the connection is established
short="${name% - Find My}"
for _ in $(seq 1 20); do
	now="$(SwitchAudioSource -a -t output 2>/dev/null)"
	target="$(echo "$now" | grep -Fx -e "$name" -e "$short" | head -n1)"
	[ -z "$target" ] && target="$(comm -13 <(echo "$before" | sort) <(echo "$now" | sort) | head -n1)"
	if [ -n "$target" ]; then
		switch_to "$target"
		break
	fi
	sleep 0.5
done

finish
