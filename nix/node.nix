{ pkgs }:
with pkgs; [
  # Formatting (global, used across projects)
  nodePackages.prettier

  # Dep management helper
  nodePackages.npm-check-updates

  # Static serving (handy globally)
  nodePackages.serve
]
# Removed: typescript, eslint — project-local (each project pins its own version)
# Removed: vite, webpack, jest — 100% project-local, never install these globally
# Removed: nodemon — use mise-managed node + project devShell
# Removed: audit-ci — CI tool, lives in the project
