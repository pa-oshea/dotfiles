{ pkgs }:

with pkgs; [
  # --- SHELL UI (Managed by Nix) ---
  starship        # Cross-shell prompt

  # --- FILE & SEARCH (Modern Replacements) ---
  fd ripgrep bat eza fzf zoxide
  
  # --- TEXT & DATA ---
  jq yq-go glow fx
  
  # --- SYSTEM MONITORING ---
  bottom btop dust procs neofetch fastfetch
  
  # --- NETWORK TOOLS ---
  curl httpie netcat
  
  # --- ARCHIVE HANDLING ---
  unzip gzip
  
  # --- VERSION CONTROL ---
  git git-lfs lazygit delta git-absorb gh
  
  # --- TERMINAL & EDITING ---
  tmux tmux-sessionizer neovim luarocks
  
  # --- FILE MANAGEMENT ---
  tree yazi rsync
  
  # --- DEV WORKFLOW ---
  direnv just mise gum
  
  # --- ANALYSIS & BENCHMARKING ---
  tokei hyperfine atac
  
  # --- CONTAINER & K8S CLIENTS (CLI tools only) ---
  dive lazydocker kubectl helm k9s
  
  # --- LINTING ---
  shellcheck yamllint
  
  # --- DATABASE ---
  sqlite
  
  # --- HELP & DOCS ---
  which tealdeer navi
  
  # --- UTILITIES ---
  watch entr parallel
  stdenv.cc.cc.lib # Essential for Neovim Treesitter
]
