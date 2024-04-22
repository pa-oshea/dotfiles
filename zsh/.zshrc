# Lines configured by zsh-newuser-install
HISTFILE=~/.cache/zsh/.histfile
HISTSIZE=1000
SAVEHIST=1000
VIM="nvim"

# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

# tmux sessionizer
bindkey -s "^f" 'tmux-sessionizer.sh\n'

export EDITOR=nvim
export VISUAL=nvim
export FZF_DEFAULT_OPTS="\
	--reverse \
	--border \
	-e \
	--no-scrollbar \
	--height=90% \
	--padding=1 \
	--preview-window=right:50%:wrap \
	--bind shift-up:preview-up,shift-down:preview-down --bind ?:toggle-preview \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
	--pointer ▶ --marker "
export FZF_DEFAULT_COMMAND="fd -H -t f -E '.git/'"

AUTO_LS_COMMAND=("ll" git-status)

# Load and initialise completion system
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*:git-checkout:*' sort false # disable sort when completing `git checkout`
zstyle ':completion:*:descriptions' format '[%d]' # set descriptions format to enable group support
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # set list-colors to enable filename colorizing
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath' # preview directory's content with eza when completing cd
zstyle ':fzf-tab:*' switch-group ',' '.' # switch group using `,` and `.`
zmodload zsh/complist
compinit
_comp_options+=(globdots)
# End of lines added by compinstall

# Plugins
plug "desyncr/auto-ls"
plug "zap-zsh/vim"
plug "kutsan/zsh-system-clipboard"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "zap-zsh/exa"
plug "wfxr/forgit"
plug "Aloxaf/fzf-tab"

# options to use vi-mode from command line
autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd ' ' edit-command-line
bindkey -M vicmd 'H' vi-beginning-of-line
bindkey -M vicmd 'L' vi-end-of-line
bindkey -M vicmd -s S ciw
bindkey -M vicmd -s E 5e
bindkey -M vicmd -s B 5b

# ALIAS
alias syu="sudo pacman -Syu"
alias ls="exa -la --icons --level=1 --sort='extension'"
alias vim="nvim"
alias e="nvim ."
alias :q="exit"
alias lg="lazygit"
alias al="alias"
alias gst="git status"
alias gl="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"

alias w="weather"
alias find_dir="find_dir()"
alias touchdir="touchdir()"
alias mkcd="mkcd()"
alias list_env="list_env()"

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(direnv hook zsh)"

## Source files
[ -f ~/.config/zsh/.zshfunc ] && source ~/.config/zsh/.zshfunc


export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
