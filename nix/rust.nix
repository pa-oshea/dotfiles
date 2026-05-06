{ pkgs }:
with pkgs; [
  # Cargo tools (global, useful across all Rust work)
  cargo-watch
  cargo-edit
  cargo-outdated
  cargo-audit
  cargo-expand
  cargo-bloat
  cargo-flamegraph
  cargo-cross

  # WebAssembly
  wasm-pack
  wasmtime

  # Docs
  mdbook
]
