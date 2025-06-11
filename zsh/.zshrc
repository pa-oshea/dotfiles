# =============================================================================
# ZSH INTERACTIVE CONFIGURATION
# =============================================================================

# -----------------------------------------------------------------------------
# Oh My Zsh Configuration
# -----------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

# Theme (empty because we use Starship)
ZSH_THEME=""

# Update behavior
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 7

# Plugin configuration
plugins=(
    # Core development
    git
    docker
    docker-compose
    
    # Language support
    golang
    mvn
    npm
    nvm
    rust
    spring
    sdk
    
    # Enhanced shell experience
    fzf
    fzf-tab
    zsh-autosuggestions
    zsh-syntax-highlighting
    
    # Utilities
    alias-finder
    command-not-found
    dotenv
    eza
    sudo
    tmux
)

# Add completions to fpath before Oh My Zsh loads
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

# Optimize completion dump location
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# -----------------------------------------------------------------------------
# Completion System Optimization
# -----------------------------------------------------------------------------
# Load completions efficiently
autoload -Uz compinit

# Only regenerate compdump once per day
for dump in ~/.zcompdump(N.mh+24); do
    compinit
done
compinit -C

# -----------------------------------------------------------------------------
# Zsh Options
# -----------------------------------------------------------------------------
# History options
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# Directory options
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Completion options
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt AUTO_MENU
setopt AUTO_LIST
setopt AUTO_PARAM_SLASH

# Other useful options
setopt CORRECT
setopt INTERACTIVE_COMMENTS
setopt MULTIOS
setopt NO_BEEP

# -----------------------------------------------------------------------------
# Plugin Configuration
# -----------------------------------------------------------------------------

# Alias-finder configuration
zstyle ':omz:plugins:alias-finder' autoload yes
zstyle ':omz:plugins:alias-finder' longer yes
zstyle ':omz:plugins:alias-finder' exact yes
zstyle ':omz:plugins:alias-finder' cheaper yes

# Completion styling
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no

# FZF-tab configuration
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# -----------------------------------------------------------------------------
# FZF Configuration
# -----------------------------------------------------------------------------
export FZF_DEFAULT_OPTS="\
    --reverse \
    --border \
    --no-scrollbar \
    --height=90% \
    --padding=1 \
    --preview-window=right:50%:wrap \
    --bind shift-up:preview-up,shift-down:preview-down \
    --bind '?:toggle-preview' \
    --bind 'ctrl-y:execute-silent(echo {} | pbcopy)' \
    --bind 'ctrl-e:execute(echo {} | xargs -o \$EDITOR)' \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --pointer='▶' \
    --marker=''"

# FZF key bindings (if not loaded by plugin)
if [[ ! "$plugins" =~ "fzf" ]]; then
    source <(fzf --zsh) 2>/dev/null
fi

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------

# Quick shortcuts
alias lg="lazygit"
alias ld="lazydocker"
alias q="exit"

# Enhanced utilities
alias fh='history | fzf --tac --no-sort | sed "s/ *[0-9]* *//" | tr -d "\n" | pbcopy'
alias fd='cd $(find * -type d | fzf)'
alias fkill='ps -ef | fzf | awk "{print \$2}" | xargs kill -9'

# Directory navigation
alias dev="cd $DEV_HOME"
alias work="cd $WORK_HOME"
alias dots="cd $XDG_CONFIG_HOME"

# Config editing
alias zshconfig="$EDITOR $ZDOTDIR/.zshrc"
alias zshenv="$EDITOR ~/.zshenv"
alias starconfig="$EDITOR $STARSHIP_CONFIG"

# Git shortcuts
alias gs="git status -sb"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --decorate --graph"
alias gd="git diff"
alias gb="git branch"
alias gco="git checkout"
alias gcb="git checkout -b"

# System utilities
alias ll="eza -la --git --icons --group-directories-first"
alias la="eza -la --git --icons --group-directories-first"
alias ls="eza --icons --group-directories-first"
alias lt="eza -T --git --icons --level=2"

# System monitoring
alias df="df -h"
alias du="du -sh"
alias ports="ss -tuln"
alias listening="ss -tlnp"

# -----------------------------------------------------------------------------
# Tool Initialization
# -----------------------------------------------------------------------------

# Initialize Starship prompt
eval "$(starship init zsh)"

# Initialize zoxide (smart cd)
eval "$(zoxide init --cmd cd zsh)"

# Initialize mise
eval "$(mise activate zsh)"

# Load custom functions
[[ -f "$ZDOTDIR/.zshfunc" ]] && source "$ZDOTDIR/.zshfunc"

# Load local configuration if it exists
[[ -f "$ZDOTDIR/.zshrc.local" ]] && source "$ZDOTDIR/.zshrc.local"
