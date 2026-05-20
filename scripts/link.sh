#!/usr/bin/env bash
# =============================================================================
# link.sh — symlink dotfiles into ~
# Run from anywhere; resolves the dotfiles root automatically.
# Usage:
#   ./scripts/link.sh          # link everything
#   ./scripts/link.sh --dry-run  # preview without making changes
# =============================================================================

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY_RUN=false

[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------
info() { echo "  [info]  $*"; }
success() { echo "  [ok]    $*"; }
skip() { echo "  [skip]  $*"; }
dry() { echo "  [dry]   would link: $2 → $1"; }
fail() { echo "  [error] $*" >&2; }

link() {
  local src="$1" # absolute path inside dotfiles repo
  local dst="$2" # absolute path in ~

  if $DRY_RUN; then
    dry "$src" "$dst"
    return
  fi

  # Create parent directory if it doesn't exist
  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" ]]; then
    local current
    current="$(readlink "$dst")"
    if [[ "$current" == "$src" ]]; then
      skip "$dst (already linked)"
      return
    else
      info "$dst points elsewhere ($current) — relinking"
      ln -sf "$src" "$dst"
      success "$dst → $src"
    fi
  elif [[ -e "$dst" ]]; then
    local backup="${dst}.bak.$(date +%Y%m%d_%H%M%S)"
    info "backing up existing $dst → $backup"
    mv "$dst" "$backup"
    ln -sf "$src" "$dst"
    success "$dst → $src"
  else
    ln -sf "$src" "$dst"
    success "$dst → $src"
  fi
}

# -----------------------------------------------------------------------------
# Dotfiles map: link "$DOTFILES/<src>" "$HOME/<dst>"
# Add new entries here as you add configs to the repo.
# -----------------------------------------------------------------------------
echo ""
echo "Dotfiles: $DOTFILES"
echo "Target:   $HOME"
$DRY_RUN && echo "(dry run — no changes will be made)"
echo ""

# Shell
link "$DOTFILES/.zshenv" "$HOME/.zshenv"
link "$DOTFILES/zsh/.zshenv" "$HOME/.config/zsh/.zshenv"
link "$DOTFILES/zsh/.zshrc" "$HOME/.config/zsh/.zshrc"
link "$DOTFILES/zsh/.zshalias" "$HOME/.config/zsh/.zshalias"
link "$DOTFILES/zsh/.zshfunc" "$HOME/.config/zsh/.zshfunc"

# Git
link "$DOTFILES/.gitconfig" "$HOME/.gitconfig"

# Tmux
link "$DOTFILES/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

# Starship
link "$DOTFILES/starship/starship.toml" "$HOME/.config/starship/starship.toml"

# Yazi
link "$DOTFILES/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"
link "$DOTFILES/yazi/keymap.toml" "$HOME/.config/yazi/keymap.toml"
link "$DOTFILES/yazi/theme.toml" "$HOME/.config/yazi/theme.toml"

# Ripgrep
link "$DOTFILES/ripgrep/config" "$HOME/.config/ripgrep/config"

# Mise
link "$DOTFILES/mise/config.toml" "$HOME/.config/mise/config.toml"

# Scripts → ~/.local/bin (make executable after linking)
link "$DOTFILES/scripts/tmux-sessionizer.sh" "$HOME/.local/bin/tmux-sessionizer.sh"
link "$DOTFILES/scripts/tmux-status-info.sh" "$HOME/.local/bin/tmux-status-info.sh"
link "$DOTFILES/scripts/clipboard-copy" "$HOME/.local/bin/clipboard-copy"
link "$DOTFILES/scripts/clipboard-paste" "$HOME/.local/bin/clipboard-paste"

# Ensure scripts are executable
if ! $DRY_RUN; then
  chmod +x "$HOME/.local/bin/tmux-sessionizer.sh" 2>/dev/null || true
  chmod +x "$HOME/.local/bin/tmux-status-info.sh" 2>/dev/null || true
  chmod +x "$HOME/.local/bin/clipboard-copy"
  chmod +x "$HOME/.local/bin/clipboard-paste"
fi

echo ""
echo "Done."
