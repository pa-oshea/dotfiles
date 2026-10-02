{ pkgs }:
with pkgs; [
  # File & search
  fd ripgrep bat eza fzf zoxide sd ast-grep

  # Text & data
  jq yq-go glow fx visidata lnav

  # System monitoring
  bottom btop dust procs fastfetch

  # Network
  httpie netcat

  # Archive
  unzip gzip

  # Version control
  git-lfs lazygit delta git-absorb gh

  # Terminal & multiplexers
  tmux tmux-sessionizer zellij

  # Editor
  neovim lua5_1 luarocks tree-sitter

  # File management
  tree yazi rsync

  # Dev workflow
  direnv just gum

  # Analysis & benchmarking
  tokei hyperfine atac

  # Container & k8s
  dive lazydocker kubectl helm k9s openshift stern kubectx kcat

  # Linting
  shellcheck yamllint

  # Database
  sqlite

  # Help & docs
  which tealdeer navi

  # Utilities
  watch entr parallel stow

  # Prompt & shell tools
  starship atuin

  # Build tools
  gcc gnumake pkg-config

  # Zsh plugins (sourced from Nix store in .zshrc — no plugin manager needed)
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  zsh-fzf-tab
  zsh-forgit
]
