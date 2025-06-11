# Rust development toolchain and utilities
# Usage: nix-env -if ~/.dotfiles/nix/packages/languages/rust.nix

{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  # Essential cargo tools
  cargo-watch            # Auto-rebuild on file changes
  cargo-edit             # Edit Cargo.toml from command line
  cargo-outdated         # Check for outdated dependencies
  cargo-audit            # Security vulnerability scanner
  cargo-expand           # Show macro expansions
  
  # Performance & analysis
  cargo-bloat            # Find what takes space in binary
  cargo-flamegraph       # Flamegraph profiling
  
  # Cross-compilation
  cargo-cross            # Cross-compilation tool
  
  # WebAssembly
  wasm-pack              # WebAssembly package builder
  wasmtime               # WebAssembly runtime
  
  # Documentation
  mdbook                 # Rust documentation book generator
  
  # System dependencies often needed
  pkg-config             # Package configuration
  openssl                # SSL/TLS library
  gcc                    # C compiler (for some crates)
]
