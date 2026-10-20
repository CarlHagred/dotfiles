#!/usr/bin/env bash

set -e

echo "🔧 Setting up your macOS environment..."

# Install Xcode Command Line Tools if missing
if ! xcode-select -p &>/dev/null; then
  echo "🛠 Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "ℹ️ Please re-run this script after the tools finish installing."
  exit 1
else
  echo "✅ Xcode Command Line Tools already installed."
fi

# Ensure Homebrew is installed
if ! command -v brew &>/dev/null; then
  echo "🍺 Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew already installed."
fi

# Install packages from Brewfile
echo "📦 Installing Homebrew packages..."
brew bundle --file="$HOME/.config/homebrew/Brewfile"

# Set Fish as default shell if not already
if [ "$SHELL" != "/opt/homebrew/bin/fish" ]; then
  echo "🐟 Setting Fish as default shell..."
  chsh -s /opt/homebrew/bin/fish
fi

# install Rust
if ! command -v rustc &>/dev/null; then
  echo "🦀 Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
  cargo install cargo-generate
else
  echo "✅ Rust already installed."
fi

# install UV
if ! command -v uv &>/dev/null; then
  echo "🔆 Installing UV..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  uv tool install ruff@latest
else
  echo "✅ UV already installed."
fi

# Create ty language server wrapper for Neovim
echo "🔤 Setting up ty language server..."
mkdir -p "$HOME/.local/bin"
cat > "$HOME/.local/bin/ty-server" << 'SCRIPT'
#!/bin/bash
exec uvx --default-index https://pypi.org/simple/ ty server "$@"
SCRIPT
chmod +x "$HOME/.local/bin/ty-server"

# Run macOS defaults script
echo " Applying macOS defaults..."
"$HOME/.config/macos/macos_defaults.sh"

# Build the native SketchyBar helper (needs Xcode Command Line Tools)
echo "🔨 Building sketchybar helper..."
make -C "$HOME/.config/sketchybar/helpers"

# Install and start sketchybar
echo "🚀 Installing and starting sketchybar..."
sketchybar --install-service
sketchybar --start-service

#install fisher
if ! command -v fisher &>/dev/null; then
  echo "🔆 Installing fisher..."
  curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
else
  echo "✅ Fisher already installed."
fi

#install nvm
if ! command -v nvm &>/dev/null; then
  echo "🔆 Installing UV..."
  fisher install jorgebucaran/nvm.fish
else
  echo "✅ nvm already installed."
fi

# Create hushlogin to suppress login message
touch ~/.hushlogin

echo "✅ All done! Restart your terminal to apply changes."
