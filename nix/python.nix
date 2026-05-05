# Python development tools
# Usage: nix-env -if ~/.dotfiles/nix/packages/languages/python.nix
# Note: Use mise for actual Python runtime management

{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  # Package management
  poetry                 # Dependency management
  pipx                   # Install Python applications
  
  # Code quality tools
  black                  # Code formatter
  isort                  # Import sorter
  flake8                 # Linter
  mypy                   # Type checker
  bandit                 # Security linter
  
  # Testing
  python3Packages.tox    # Testing in multiple environments
  
  # Development tools
  python3Packages.jupyter # Jupyter notebooks
  
  # Documentation
  python3Packages.sphinx # Documentation generator
  
  # Utilities
  python3Packages.rich   # Rich text and beautiful formatting
  python3Packages.typer  # CLI framework
]
