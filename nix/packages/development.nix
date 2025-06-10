# Development tools and workflow enhancers
# Usage: nix-env -if ~/.dotfiles/nix/packages/development.nix

{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  # Enhanced git workflow
  lazygit                # Git TUI
  delta                  # Better git diff viewer
  git-absorb             # Automatic git commit fixups
  gh                     # GitHub CLI
  
  # Development workflow tools
  gum                    # Beautiful shell script components
  direnv                 # Automatic environment loading
  just                   # Command runner (better than make)
  mise                   # Runtime version manager (replaces nvm, rbenv, etc.)
  
  # Code analysis & statistics
  tokei                  # Code statistics (lines of code)
  hyperfine              # Command-line benchmarking
  
  # API development
  atac                   # API testing TUI (REST client)
  
  # File management
  yazi                   # Terminal file manager
  
  # Documentation & help
  navi                   # Interactive cheatsheet tool
  
  # Container tools
  docker                 # Container platform
  docker-compose         # Container orchestration
  dive                   # Docker image analyzer
  lazydocker             # Docker TUI
  
  # Kubernetes tools
  kubectl                # Kubernetes CLI
  helm                   # Kubernetes package manager
  k9s                    # Kubernetes TUI
  
  # Infrastructure as Code
  terraform              # Infrastructure provisioning
  ansible                # Configuration management
  
  # Cloud CLIs
  awscli2                # AWS CLI
  google-cloud-sdk       # Google Cloud SDK
  
  # Language tooling
  shellcheck             # Shell script linter
  yamllint               # YAML linter
  
  # Security & encryption
  age                    # File encryption
  gnupg                  # GNU Privacy Guard
  
  # Database tools
  sqlite                 # SQLite CLI
  
  # Network debugging
  netcat                 # Network swiss army knife
  
  # File synchronization
  rsync                  # File synchronization
  
  # Utilities
  watch                  # Execute programs periodically
  entr                   # Run commands when files change
  parallel               # Execute jobs in parallel
  fx                     # Interactive JSON viewer
]
