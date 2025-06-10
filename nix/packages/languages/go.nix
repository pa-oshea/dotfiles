# Go development tools
# Usage: nix-env -if ~/.dotfiles/nix/packages/languages/go.nix
# Note: Use mise for actual Go runtime management

{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  # Go runtime (fallback)
  go                     # Go compiler and tools
  
  # Development tools
  gopls                  # Go Language Server
  golangci-lint          # Fast Go linters runner
  govulncheck            # Go vulnerability checker
  
  # Code quality
  gofumpt                # Stricter gofmt
  goimports              # Auto-import management
  golines                # Go formatter that shortens long lines
  
  # Testing & profiling
  gotests                # Generate Go tests
  pprof                  # Profiling tool
  
  # Build & deployment
  goreleaser             # Release automation
  
  # Debugging
  delve                  # Go debugger
  
  # Documentation
  godoc                  # Documentation tool
  
  # Popular Go CLI tools (examples of what Go can build)
  lazygit                # Git TUI (built with Go)
  lazydocker             # Docker TUI (built with Go)
  k9s                    # Kubernetes TUI (built with Go)
  
  # Utilities
  air                    # Live reload for Go apps
  modd                   # File watcher and task runner
]
