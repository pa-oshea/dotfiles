# Node.js development tools
# Usage: nix-env -if ~/.dotfiles/nix/packages/languages/node.nix
# Note: Use mise/nvm for actual Node.js runtime management

{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  # Development tools
  typescript             # TypeScript compiler
  eslint                 # JavaScript/TypeScript linter
  prettier               # Code formatter
  
  # Build tools
  vite                   # Fast build tool
  webpack                # Module bundler
  
  # Testing
  jest                   # Testing framework
  
  # Utilities
  serve                  # Static file server
  nodemon                # Auto-restart on changes
  npm-check-updates      # Check for package updates
  
  # Security
  audit-ci               # Security audit in CI
]
