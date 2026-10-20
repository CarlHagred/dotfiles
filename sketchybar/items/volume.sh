#!/usr/bin/env bash
# Volume pill (status island). Popup: slider, mute row, output / input / Bluetooth devices.

sketchybar \
	--add item volume right \
	--set volume \
	"${PILL_STYLE[@]}" \
	icon.color="$ICON_COLOR" \
	label.color="$LABEL_COLOR" \
	popup.align=right \
	"${POPUP_PILL_STYLE[@]}" \
	script="$PLUGIN_DIR/volume/volume.sh" \
	--subscribe volume volume_change mouse.clicked mouse.scrolled mouse.entered mouse.exited

# Popup rows below the slider; the device rows are rebuilt by plugins/volume/devices.sh.
sketchybar \
	--add slider volume.slider popup.volume 190 \
	--set volume.slider \
	"${SLIDER_STYLE[@]}" \
	slider.background.height=8 \
	slider.background.corner_radius=4 \
	script="$PLUGIN_DIR/volume/slider.sh" \
	--subscribe volume.slider mouse.clicked \
	\
	--add item volume.mute popup.volume \
	--set volume.mute "${POPUP_ROW_STYLE[@]}" \
	icon="󰖁" \
	label="Mute" \
	click_script="$PLUGIN_DIR/volume/mute.sh" \
	\
	--add item volume.sep popup.volume \
	--set volume.sep "${POPUP_RULE_STYLE[@]}" width=200
