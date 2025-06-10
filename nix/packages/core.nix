# Essential CLI utilities - the foundation for all profiles
# Usage: nix-env -if ~/.dotfiles/nix/packages/core.nix

{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  # Shell essentials
  zsh                    # Z shell
  starship               # Cross-shell prompt
  
  # File operations (modern replacements)
  fd                     # Modern find replacement
  ripgrep                # Modern grep replacement
  bat                    # Modern cat with syntax highlighting
  eza                    # Modern ls with git integration
  
  # Navigation & search
  fzf                    # Fuzzy finder
  zoxide                 # Smart cd replacement
  
  # Text processing & viewing
  jq                     # JSON processor
  yq-go                  # YAML processor
  glow                   # Markdown viewer
  fx                     # Interactive JSON viewer
  
  # System monitoring
  bottom                 # Modern htop replacement (btm command)
  btop                   # Alternative modern htop
  dust                   # Modern du replacement
  procs                  # Modern ps replacement
  neofetch               # System information tool
  
  # Network tools
  curl                   # HTTP client
  httpie                 # User-friendly HTTP client
  netcat                 # Network swiss army knife
  
  # Archive handling
  unzip                  # ZIP extraction
  gzip                   # GNU zip
  
  # Clipboard utilities
  xsel                   # X11 clipboard tool
  xclip                  # Alternative clipboard tool
  
  # Version control
  git                    # Version control system
  git-lfs                # Large file storage
  lazygit                # Git TUI
  delta                  # Better git diff viewer
  git-absorb             # Automatic git commit fixups
  gh                     # GitHub CLI
  
  # Terminal & editing
  tmux                   # Terminal multiplexer
  tmux-sessionizer       # Sessionizer for tmux
  neovim                 # Modern text editor
  
  # File management
  tree                   # Directory tree viewer
  yazi                   # Terminal file manager
  rsync                  # File synchronization
  
  # Development workflow
  direnv                 # Automatic environment loading
  just                   # Command runner (better than make)
  mise                   # Runtime version manager
  gum                    # Beautiful shell script components
  
  # Code analysis & benchmarking
  tokei                  # Code statistics
  hyperfine              # Command-line benchmarking
  
  # API & testing tools
  atac                   # API testing TUI
  
  # Container tools
  docker                 # Container platform
  docker-compose         # Container orchestration
  dive                   # Docker image analyzer
  lazydocker             # Docker TUI
  
  # Kubernetes tools
  kubectl                # Kubernetes CLI
  helm                   # Kubernetes package manager
  k9s                    # Kubernetes TUI
  
  # Linting & code quality
  shellcheck             # Shell script linter
  yamllint               # YAML linter
  
  # Database tools
  sqlite                 # SQLite CLI
  
  # Documentation & help
  which                  # Command location finder
  tealdeer               # Fast man pages (tldr)
  navi                   # Interactive cheatsheet tool
  
  # Utilities
  watch                  # Execute programs periodically
  entr                   # Run commands when files change
  parallel               # Execute jobs in parallel
]
