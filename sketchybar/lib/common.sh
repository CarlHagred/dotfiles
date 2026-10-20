# Shared environment for every SketchyBar script. Source it first:
#   source "${CONFIG_DIR:-$HOME/.config/sketchybar}/lib/common.sh"
# SketchyBar exports CONFIG_DIR to the scripts it starts.

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
export PATH="/opt/homebrew/bin:$PATH"

ITEM_DIR="$CONFIG_DIR/items"
PLUGIN_DIR="$CONFIG_DIR/plugins"
LIB_DIR="$CONFIG_DIR/lib"
SB_HELPER="$CONFIG_DIR/helpers/bin/sbhelper"

# Scratch space shared by the scripts (caches, state, pid files)
STATE_DIR="${TMPDIR:-/tmp}/sketchybar"
mkdir -p "$STATE_DIR"

AEROSPACE_CLI="/opt/homebrew/bin/aerospace"
WORKSPACE_COUNT=5 # Used only when AeroSpace cannot list its workspaces

source "$CONFIG_DIR/theme.sh"

# popup_is_open <item>
popup_is_open() {
	[ "$(sketchybar --query "$1" 2>/dev/null | jq -r '.popup.drawing')" = "on" ]
}

# open_settings <Pane>  e.g. open_settings Sound
open_settings() {
	open "x-apple.systempreferences:com.apple.$1-Settings.extension"
}

# wifi_device -> name of the Wi-Fi interface (en0, ...)
wifi_device() {
	networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}'
}
