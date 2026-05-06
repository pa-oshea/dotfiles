{ pkgs }:
with pkgs; [
  # Linting & security
  golangci-lint
  govulncheck

  # Formatting
  gofumpt
  goimports
  golines

  # Testing
  gotests

  # Release
  goreleaser

  # Debugging
  delve

  # Docs
  godoc

  # Live reload
  air
  modd
]
