# =============================================================================
# ZSH ENVIRONMENT CONFIGURATION
# =============================================================================

# -----------------------------------------------------------------------------
# XDG Base Directory Specification
# -----------------------------------------------------------------------------
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME" "$XDG_STATE_HOME"

# -----------------------------------------------------------------------------
# Project Directories
# -----------------------------------------------------------------------------
export DEV_HOME="$HOME/dev"
export WORK_HOME="$HOME/work"
mkdir -p "$DEV_HOME" "$WORK_HOME"

# -----------------------------------------------------------------------------
# Zsh
# -----------------------------------------------------------------------------
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=100000
export SAVEHIST=100000
mkdir -p "$XDG_STATE_HOME/zsh" "$XDG_CACHE_HOME/zsh"

# -----------------------------------------------------------------------------
# Editor & Pager
# -----------------------------------------------------------------------------
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS="-R -i -w -M -z-4"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
mkdir -p "$XDG_CACHE_HOME/less"

# -----------------------------------------------------------------------------
# Language Tool Homes (XDG-compliant)
# -----------------------------------------------------------------------------

# Rust — only set if using rustup directly; mise-managed Rust ignores these
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# Go
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"
export GOCACHE="$XDG_CACHE_HOME/go-build"

# -----------------------------------------------------------------------------
# Tool Configuration
# -----------------------------------------------------------------------------
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# -----------------------------------------------------------------------------
# PATH
# -----------------------------------------------------------------------------
typeset -U path PATH

path=(
    "$HOME/.local/bin"      # local scripts (e.g. tmux-sessionizer)
    "$GOBIN"                # go binaries
    "$CARGO_HOME/bin"       # rustup/cargo binaries (if not using mise for Rust)
    "/usr/local/bin"
    $path
)

export PATH

# -----------------------------------------------------------------------------
# Runtime Tool Bootstrap
# Ordered: Nix → sdkman → mise
# sdkman must be last as it appends to PATH itself
# -----------------------------------------------------------------------------

# Nix
[[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]] \
    && source "$HOME/.nix-profile/etc/profile.d/nix.sh"

# Nix library path (needed for some dynamically linked Nix packages on non-NixOS)
export LD_LIBRARY_PATH="$HOME/.nix-profile/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

# Cargo env (if using rustup outside of mise)
[[ -f "$CARGO_HOME/env" ]] && source "$CARGO_HOME/env"

# SDKMAN — must be sourced last, it does its own PATH manipulation
export SDKMAN_DIR="$XDG_DATA_HOME/sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
