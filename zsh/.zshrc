
# =============================================================================
# ZSH INTERACTIVE CONFIGURATION
# =============================================================================

# -----------------------------------------------------------------------------
# Completion System
# -----------------------------------------------------------------------------
autoload -Uz compinit

# Regenerate compdump at most once per day
if [[ -n "$XDG_CACHE_HOME/zsh/compdump"(#qN.mh+24) ]]; then
    compinit -d "$XDG_CACHE_HOME/zsh/compdump"
else
    compinit -C -d "$XDG_CACHE_HOME/zsh/compdump"
fi

# -----------------------------------------------------------------------------
# Zsh Options
# -----------------------------------------------------------------------------
# History
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Completion
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt AUTO_MENU
setopt AUTO_LIST
setopt AUTO_PARAM_SLASH

# Misc
setopt CORRECT
setopt INTERACTIVE_COMMENTS
setopt MULTIOS
setopt NO_BEEP

# -----------------------------------------------------------------------------
# Completion Styling
# -----------------------------------------------------------------------------
zstyle ':completion:*' menu no
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:git-checkout:*' sort false

# fzf-tab
zstyle ':fzf-tab:complete:cd:*'         fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*'                     switch-group '<' '>'

# Use tmux popup if inside tmux, otherwise plain fzf (works in zellij too)
if [[ -n "$TMUX" ]]; then
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
fi

# -----------------------------------------------------------------------------
# Plugins (sourced from Nix store — no plugin manager needed)
# -----------------------------------------------------------------------------
# fpath must be set before compinit runs, but plugins source after
fpath=("$HOME/.nix-profile/share/zsh/site-functions" $fpath)
fpath=("$HOME/.nix-profile/share/zsh-completions" $fpath)

() {
    local nix="$HOME/.nix-profile"
    local -A plugins=(
        [autosugg]="$nix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
        [synhigh]="$nix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        [fzftab]="$nix/share/fzf-tab/fzf-tab.plugin.zsh"
    )
    # fzf-tab must be loaded after compinit and after syntax-highlighting
    [[ -f "${plugins[autosugg]}" ]] && source "${plugins[autosugg]}"
    [[ -f "${plugins[synhigh]}"  ]] && source "${plugins[synhigh]}"
    [[ -f "${plugins[fzftab]}"   ]] && source "${plugins[fzftab]}"
}

# -----------------------------------------------------------------------------
# Key Bindings
# -----------------------------------------------------------------------------
bindkey -e                          # Emacs key bindings (ctrl-a, ctrl-e, etc.)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

# -----------------------------------------------------------------------------
# FZF
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
    --bind 'ctrl-e:execute(echo {} | xargs -o \$EDITOR)' \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --pointer='▶' \
    --marker=''"

# Load fzf shell integration (key bindings + completion)
source <(fzf --zsh) 2>/dev/null

# -----------------------------------------------------------------------------
# Tool Initialization
# -----------------------------------------------------------------------------
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(mise activate zsh)"

# -----------------------------------------------------------------------------
# Local Overrides & Extras
# -----------------------------------------------------------------------------
[[ -f "$ZDOTDIR/.zshalias"   ]] && source "$ZDOTDIR/.zshalias"
[[ -f "$ZDOTDIR/.zshfunc"    ]] && source "$ZDOTDIR/.zshfunc"
[[ -f "$ZDOTDIR/.zshrc.local" ]] && source "$ZDOTDIR/.zshrc.local"
