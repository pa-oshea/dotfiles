{ pkgs }:
with pkgs; [
  # Formatting (global, used across projects)
  nodePackages.prettier

  # Dep management helper
  nodePackages.npm-check-updates

  # Static serving (handy globally)
  nodePackages.serve
]
