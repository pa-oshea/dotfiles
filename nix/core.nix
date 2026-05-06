{ pkgs }:
with pkgs; [
  # File & search
  fd ripgrep bat eza fzf zoxide

  # Text & data
  jq yq-go glow fx

  # System monitoring
  bottom btop dust procs fastfetch

  # Network
  httpie netcat

  # Archive
  unzip gzip

  # Version control  (remove git if CachyOS provides it)
  git-lfs lazygit delta git-absorb gh

  # Terminal & editing
  tmux neovim luarocks

  # File management
  tree yazi rsync

  # Dev workflow
  direnv just mise gum

  # Analysis & benchmarking
  tokei hyperfine atac

  # Container & k8s
  dive lazydocker kubectl helm k9s

  # Linting
  shellcheck yamllint

  # Database
  sqlite

  # Help & docs
  which tealdeer navi

  # Utilities
  watch entr parallel

  # ZSH Plugins
  zsh-autosuggestions zsh-syntax-highlighting zsh-completions zsh-fzf-tab
]
