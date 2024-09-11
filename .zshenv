# Set XDB Base Directory specification
export XDB_CONFIG_HOME="$HOME/.config"
export XDB_DATA_HOME="$HOME/.local/share"
export XDB_CACHE_HOME="$HOME/.cache"

export DEV_HOME="$HOME/dev"

# Set Zsh configuration directory
export ZDOTDIR=$HOME/.config/zsh

# Configure starship prompt
export STARSHIP_CONFIG=$HOME/.config/zsh/starship.toml

# Set editor
[ -z "$EDITOR" ] && export EDITOR="vim"
[ -z "$VISUAL" ] && export VISUAL="$EDITOR"

# Set up language-specific package managers
export CARGO_HOME="$XDB_DATA_HOME/cargo"
export GOPATH="$XDB_DATA_HOME/go"

# Modify PATH
path=(
    "$HOME/.local/bin"
    "$GOPATH/bin"
    "$CARGO_HOME/bin"
    $path
)
export PATH

# Source Cargo environment if it exists
[ -f "$CARGO_HOME/env" ] && source "$CARGO_HOME/env"

# Source nix
[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && source "$HOME/.nix-profile/etc/profile.d/nix.sh" # added by Nix installer
