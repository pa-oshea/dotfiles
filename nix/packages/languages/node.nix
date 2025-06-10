# Node.js development tools
# Usage: nix-env -if ~/.dotfiles/nix/packages/languages/node.nix
# Note: Use mise/nvm for actual Node.js runtime management

{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  # Package managers (latest versions)
  nodejs_latest          # Node.js runtime (fallback)
  yarn                   # Yarn package manager
  pnpm                   # Fast package manager
  
  # Development tools
  typescript             # TypeScript compiler
  ts-node                # TypeScript execution
  
  # Linting & formatting
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
  
  # Package analysis
  npm-check-updates      # Check for package updates
  
  # Security
  audit-ci               # Security audit in CI
]
