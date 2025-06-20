# Bootstrap .zshenv for ZDOTDIR
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Work, clear Citrix LD_PRELOAD issues
unset LD_PRELOAD
export LD_PRELOD=""

# Source the real config
[[ -f "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"
