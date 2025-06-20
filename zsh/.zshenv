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

# Create XDG directories if they don't exist
[[ ! -d "$XDG_CONFIG_HOME" ]] && mkdir -p "$XDG_CONFIG_HOME"
[[ ! -d "$XDG_DATA_HOME" ]] && mkdir -p "$XDG_DATA_HOME"
[[ ! -d "$XDG_CACHE_HOME" ]] && mkdir -p "$XDG_CACHE_HOME"
[[ ! -d "$XDG_STATE_HOME" ]] && mkdir -p "$XDG_STATE_HOME"

# -----------------------------------------------------------------------------
# Development Directories
# -----------------------------------------------------------------------------
export DEV_HOME="$HOME/dev"
[[ ! -d "$DEV_HOME" ]] && mkdir -p "$DEV_HOME"


# -----------------------------------------------------------------------------
# Work Directories
# -----------------------------------------------------------------------------
export WORK_HOME="$HOME/work"
[[ ! -d "$WORK_HOME" ]] && mkdir -p "$WORK_HOME"

# -----------------------------------------------------------------------------
# Zsh Configuration
# -----------------------------------------------------------------------------
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# Zsh history configuration
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=100000
export SAVEHIST=100000

# Create zsh state directory
[[ ! -d "$XDG_STATE_HOME/zsh" ]] && mkdir -p "$XDG_STATE_HOME/zsh"

# -----------------------------------------------------------------------------
# Editor Configuration
# -----------------------------------------------------------------------------
export EDITOR="nvim"
export VISUAL="nvim"

# -----------------------------------------------------------------------------
# Pager Configuration
# -----------------------------------------------------------------------------
export PAGER="less"
export LESS="-R -i -w -M -z-4"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"

# Create less cache directory
[[ ! -d "$XDG_CACHE_HOME/less" ]] && mkdir -p "$XDG_CACHE_HOME/less"

# -----------------------------------------------------------------------------
# Development Tools Configuration
# -----------------------------------------------------------------------------

# Rust/Cargo
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# Go
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"
export GOCACHE="$XDG_CACHE_HOME/go-build"

# -----------------------------------------------------------------------------
# Tool Configuration
# -----------------------------------------------------------------------------

# FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Ripgrep
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# -----------------------------------------------------------------------------
# PATH Configuration
# -----------------------------------------------------------------------------
# Create a clean PATH, avoiding duplicates
typeset -U path PATH

# Local binaries (highest priority)
path=(
    "$HOME/.local/bin"
    $path
)

# Development tool binaries
path=(
    "$GOBIN"
    "$CARGO_HOME/bin"
    $path
)

# System binaries
path=(
    "/usr/local/bin"
    "/usr/local/go/bin"
    $path
)

export PATH

# -----------------------------------------------------------------------------
# Conditional Environment Loading
# -----------------------------------------------------------------------------

# Source Cargo environment if it exists
[[ -f "$CARGO_HOME/env" ]] && source "$CARGO_HOME/env"

# Source Nix environment if it exists
[[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"

# SDKMAN (keep at end as it modifies PATH)
export SDKMAN_DIR="$XDG_DATA_HOME/sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
