#!/usr/bin/env bash
# Network pill (status island). Popup: connection details, copyable addresses, Wi-Fi switch.

sketchybar --add item network right \
	--set network \
	"${PILL_STYLE[@]}" \
	update_freq=10 \
	icon.color="$ICON_COLOR" \
	icon.padding_right=9 \
	label.color="$LABEL_COLOR" \
	label.drawing=off \
	popup.align=right \
	"${POPUP_PILL_STYLE[@]}" \
	script="$PLUGIN_DIR/network/network.sh" \
	--subscribe network mouse.clicked mouse.entered mouse.exited system_woke

# Popup rows, filled by plugins/network/popup.sh. Monospaced labels keep the columns aligned.
sketchybar \
	--add item network.title popup.network \
	--set network.title "${INFO_ROW_STYLE[@]}" label.color="$ACCENT" \
	--add item network.detail popup.network \
	--set network.detail "${INFO_ROW_STYLE[@]}" label.color="$ICON_DIM_COLOR" \
	--add item network.ip popup.network \
	--set network.ip "${INFO_ROW_STYLE[@]}" click_script="$PLUGIN_DIR/network/copy.sh ip" \
	--add item network.router popup.network \
	--set network.router "${INFO_ROW_STYLE[@]}" click_script="$PLUGIN_DIR/network/copy.sh router" \
	--add item network.sep popup.network \
	--set network.sep "${POPUP_RULE_STYLE[@]}" width=230 \
	--add item network.toggle popup.network \
	--set network.toggle "${INFO_ROW_STYLE[@]}" click_script="$PLUGIN_DIR/network/toggle.sh"
