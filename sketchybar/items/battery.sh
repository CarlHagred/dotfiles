#!/usr/bin/env bash
# Battery pill (status island). Popup: state, time left, source, health and cycle count.

sketchybar --add item battery right \
	--set battery \
	"${PILL_STYLE[@]}" \
	update_freq=120 \
	icon.color="$ICON_COLOR" \
	label.color="$LABEL_COLOR" \
	popup.align=right \
	"${POPUP_PILL_STYLE[@]}" \
	script="$PLUGIN_DIR/battery/battery.sh" \
	--subscribe battery power_source_change mouse.clicked mouse.entered mouse.exited

# Popup rows, filled by plugins/battery/popup.sh. Monospaced labels keep the columns aligned.
sketchybar \
	--add item battery.title popup.battery \
	--set battery.title "${INFO_ROW_STYLE[@]}" label.color="$ACCENT" \
	--add item battery.time popup.battery \
	--set battery.time "${INFO_ROW_STYLE[@]}" \
	--add item battery.source popup.battery \
	--set battery.source "${INFO_ROW_STYLE[@]}" \
	--add item battery.sep popup.battery \
	--set battery.sep "${POPUP_RULE_STYLE[@]}" width=230 \
	--add item battery.health popup.battery \
	--set battery.health "${INFO_ROW_STYLE[@]}" label.color="$ICON_DIM_COLOR" \
	--add item battery.cycles popup.battery \
	--set battery.cycles "${INFO_ROW_STYLE[@]}" label.color="$ICON_DIM_COLOR"
