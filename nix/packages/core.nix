# Essential CLI utilities - the foundation for all profiles
# Usage: nix-env -if ~/.dotfiles/nix/packages/core.nix

{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  # Shell essentials
  zsh                    # Z shell
  starship               # Cross-shell prompt
  
  # File operations (modern replacements)
  fd                     # Modern find (replaces find)
  ripgrep                # Modern grep (replaces grep)
  bat                    # Modern cat with syntax highlighting
  eza                    # Modern ls with git integration
  
  # Navigation & search
  fzf                    # Fuzzy finder
  zoxide                 # Smart cd replacement
  
  # Text processing & viewing
  jq                     # JSON processor
  yq-go                  # YAML processor
  glow                   # Markdown viewer
  
  # System monitoring (modern alternatives)
  bottom                 # Modern htop (btm command)
  btop                   # Another modern htop alternative
  dust                   # Modern du
  procs                  # Modern ps
  neofetch               # System information tool
  
  # Network tools
  curl                   # HTTP client
  httpie                 # User-friendly HTTP client
  
  # Archive handling
  unzip                  # ZIP extraction
  gzip                   # GNU zip
  
  # Clipboard tools
  xsel                   # X11 clipboard tool
  xclip                  # Alternative clipboard tool
  
  # Essential utilities
  git                    # Version control
  tmux                   # Terminal multiplexer
  neovim                 # Modern text editor
  tree                   # Directory tree viewer
  which                  # Command location
  tealdeer               # Fast man pages (tldr)
]
