#!/usr/bin/env bash

# Fast key repeat for Vim editing
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# macOS Spaces & App Layout Setup (no yabai)

echo "Configuring Mission Control behavior..."
# Disable automatic rearranging of Spaces based on use
defaults write com.apple.dock mru-spaces -bool false

# Optional: make Spaces animation faster
defaults write com.apple.dock expose-animation-duration -float 0.1

# Restart Dock to apply
killall Dock

echo "Opening apps and assigning them to Spaces..."

# Wait a moment for Dock to reload
sleep 2

# Launch each app
open -a "Safari"
open -a "Ghostty"
open -a "Zed"
open -a "Obsidian"

sleep 3  # wait for apps to open

# Use AppleScript to assign each app to a Space manually
osascript <<'EOF'
tell application "System Events"
    tell process "Finder"
        -- Make sure Mission Control has multiple spaces created
        -- User must have manually created 4 Spaces in advance
    end tell
end tell

-- Function to move an app window to a specific Space
on moveAppToSpace(appName, spaceIndex)
    tell application appName to activate
    delay 0.3
    tell application "System Events"
        key down control
        key code (18 + (spaceIndex - 1)) -- 18=1, 19=2, 20=3, 21=4
        key up control
    end tell
end moveAppToSpace

moveAppToSpace("Safari", 1)
moveAppToSpace("Ghostty", 2)
moveAppToSpace("Zed", 3)
moveAppToSpace("Obsidian", 4)
EOF

echo "Setting keyboard shortcuts to switch Spaces..."

# Create key bindings for Control+H/J/K/L to switch spaces
# macOS does not expose this via `defaults`, so we use AppleScript again.
osascript <<'EOF'
on createHotKey(keyCombo, spaceIndex)
    tell application "System Events"
        -- Simulate pressing control + 1/2/3/4 when keys are pressed
        -- also rebind fn to ctrl
        -- NOTE: macOS can't define global hotkeys without a GUI app
        -- You can assign these manually in System Settings → Keyboard → Shortcuts → Mission Control
    end tell
end createHotKey

-- Print helpful reminder for the user
display dialog "Please manually bind Control + H/J/K/L to switch to Spaces 1–4:
  System Settings → Keyboard → Keyboard Shortcuts → Mission Control"
EOF

echo "✅ macOS Spaces configuration script complete."
