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

  # Version control
  git-lfs lazygit delta git-absorb gh

  # Terminal & multiplexers
  tmux zellij

  # Editor
  neovim luarocks

  # File management
  tree yazi rsync

  # Dev workflow
  direnv just gum

  # Analysis & benchmarking
  tokei hyperfine atac

  # Container & k8s
  dive lazydocker kubectl helm k9s

  # Linting
  shellcheck yamllint

  # Clipboard (Wayland)
  wl-clipboard

  # Database
  sqlite

  # Help & docs
  which tealdeer navi

  # Utilities
  watch entr parallel stow

  # Prompt & shell tools
  starship

  # Zsh plugins (sourced from Nix store in .zshrc — no plugin manager needed)
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  zsh-fzf-tab
]
