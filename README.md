# 🛠️ My macOS Dotfiles

Welcome to my dotfiles! This repo sets up my macOS development environment, including:

- 🐟 Shell (Fish + Starship prompt)
- 🪟 Terminal (Ghostty)
- 🧠 Editors (Zed, Neovim)
- 🪟 Window Manager (AeroSpace)
- 📊 Status Bar (Sketchybar)
- ⌨️ Keyboard (Karabiner-Elements)
- 🧰 CLI tools via Homebrew

Everything is organized under `~/.config/` and tracked here for portability and versioning.

---

## 📦 Requirements

Before using these dotfiles, make sure you have:

- macOS (tested on Sonoma or later)
- Xcode Command Line Tools:
  ```sh
  xcode-select --install
  ```
- Git
- Homebrew (install if missing):
  ```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

---

## 🚀 Installation

Clone this repo into your `.config` directory:

```sh
git clone https://github.com/CarlHagred/dotfiles.git ~/.config
```

Then run the bootstrap script to install everything:

```sh
chmod +x ~/.config/bootstrap.sh
~/.config/bootstrap.sh
```

---

## 🛠 Bootstrap

The `bootstrap.sh` script automates the full setup:

1. Installs Xcode Command Line Tools (if missing)
2. Installs Homebrew (if missing)
3. Installs all packages from `homebrew/Brewfile`
4. Sets Fish as the default shell
5. Installs Rust via rustup
6. Installs UV (Python package manager)
7. Sets up the `ty` language server for Neovim
8. Applies macOS defaults (key repeat, Dock behavior)
9. Installs and starts Sketchybar
10. Installs Fisher + nvm.fish
11. Creates `~/.hushlogin`

---

## 🍺 Homebrew Packages

All packages are declared in `homebrew/Brewfile`:

**CLI tools:**
`fish`, `starship`, `fzf`, `eza`, `zoxide`, `fd`, `btop`, `lazygit`, `nvim`, `node`, `go`, `rustup`, `terraform`, `podman`, `zellij`, `just`, `sketchybar`, `borders`, `azure-cli`, `azure-functions-core-tools@4`, `mas`, `tailscale`, `leader-key`

**GUI apps (casks):**
`Ghostty`, `Zed`, `AeroSpace`, `Arc`, `Obsidian`, `Raycast`, `1Password`, `Karabiner-Elements`, `Bruno`, `Keka`, `Windows App`, `Tailscale`

**Fonts:**
`MesloLG Nerd Font`, `JetBrainsMono Nerd Font`

**Mac App Store:**
`Vimlike`, `Wipr`, `Obsidian Web Clipper`, `1Password for Safari`

Install with:
```sh
brew bundle --file=~/.config/homebrew/Brewfile
```

---

## 🐟 Fish Shell

Set Fish as your default shell:

```sh
chsh -s /opt/homebrew/bin/fish
```

Config in `fish/config.fish` includes:

- Aliases for `git`, `eza`, Python venvs, and Azure Functions
- Homebrew shellenv initialization
- Starship prompt + Zoxide
- Custom `$PATH` (Go, local bin)

---

## 🪟 Ghostty (Terminal)

Config in `ghostty/config`:

- Font: JetBrainsMono Nerd Font
- Theme: Catppuccin Mocha
- Background opacity: 85%
- Hidden titlebar

---

## 🪟 AeroSpace (Window Manager)

AeroSpace replaces macOS Spaces with a tiling window manager. Config in `aerospace/aerospace.toml`:

- Starts at login
- 5 persistent workspaces
- Keybindings: `cmd-h/j/k/l` for focus, `cmd-shift-h/j/k/l` for moving windows
- Workspace switching: `cmd-1` through `cmd-5`
- Integrates with Sketchybar for workspace indicators
- Uses JankyBorders for window borders

---

## 📊 Sketchybar (Status Bar)

Custom macOS status bar. Config in `sketchybar/`:

- Workspace indicators (via AeroSpace integration)
- Installed and started by `bootstrap.sh`

---

## 🧠 Neovim

Config in `nvim/`. The `ty` language server (Python) is set up by bootstrap via a wrapper script at `~/.local/bin/ty-server`.

---

## 🧠 Zed Editor

Settings in `zed/settings.json`. Installed via Homebrew:

```sh
brew install --cask zed
```

---

## ⌨️ Karabiner-Elements

Keyboard remapping config in `karabiner/`. Installed via Homebrew.

---

## ⭐ Starship Prompt

Config in `starship.toml`. Initialized in Fish config:

```fish
starship init fish | source
```

---

## 📁 Directory Structure

```
.config/
├── aerospace/         # AeroSpace tiling WM config
├── fish/              # Fish shell config & aliases
├── ghostty/           # Ghostty terminal config
├── homebrew/          # Brewfile
├── karabiner/         # Karabiner-Elements keyboard remapping
├── macos/             # macOS defaults script
├── nvim/              # Neovim config
├── sketchybar/        # Sketchybar status bar config
├── zed/               # Zed editor settings
├── starship.toml      # Starship prompt config
└── bootstrap.sh       # One-command setup script
```

---

## 🔄 Keeping It in Sync

After making changes:

```sh
cd ~/.config
git add .
git commit -m "Update dotfiles"
git push
```

---

## 💬 License & Attribution

This repo is for personal use, but feel free to fork or adapt!

- Theme: [Catppuccin](https://github.com/catppuccin)
- Fonts: [Nerd Fonts](https://www.nerdfonts.com)
- Window Manager: [AeroSpace](https://github.com/nikitabobko/AeroSpace)
- Status Bar: [Sketchybar](https://github.com/FelixKratz/SketchyBar)
