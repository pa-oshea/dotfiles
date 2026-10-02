# Global Copilot Instructions

This file is symlinked to `~/.copilot/copilot-instructions.md` and applies to
every GitHub Copilot CLI session on this machine, regardless of repository.

## Environment

- OS: Linux. Shell: zsh (`zsh/.zshrc`), prompt via starship.
- Dotfiles are managed declaratively from `~/.dotfiles` and linked into `~`
  via `mise dotfiles link` (see `~/.dotfiles/mise.toml`'s `[dotfiles]` table).
  Do not suggest GNU Stow — it's no longer the active dotfiles manager.
- CLI tools are installed via Nix (`nix/*.nix` in the dotfiles repo), **not**
  system package managers (pacman/apt/brew). Language runtimes (Java, Go,
  Node, Rust) are installed and version-pinned via **mise**, not Nix.
- The full, authoritative list of installed tools, what each is for, and how
  to use it (including existing aliases) lives in
  `~/.dotfiles/TOOLS.md`. Consult it before assuming a tool is unavailable or
  before reaching for a less idiomatic alternative.

## Tool preferences

Prefer the modern CLI tools already installed over legacy defaults when both
are available and the task doesn't require strict POSIX behavior:

- `rg` over `grep`, `fd` over `find`, `bat` over `cat`, `eza` over `ls`
- `sd` over `sed` for simple find/replace; `ast-grep` for structural
  code search/rewrites instead of regex-based greps when precision matters
- `jq`/`yq-go` for JSON/YAML, `visidata` for exploring tabular/CSV data
- `lnav` for multi-file/log analysis instead of manual `tail`/`grep` chains
- `kubectl`/`oc` (OpenShift) for Kubernetes work, `stern` for multi-pod log
  tailing, `kubectx`/`kubens` for cluster/namespace switching
- `lazygit` for interactive git staging/review when a TUI helps
- `atuin` provides shell history search (`Ctrl-R`); history sync is not
  configured, it is local-only

## Note-taking (Zettelkasten)

- Notes live in `~/work/notes`, a PARA/Zettelkasten-style vault managed with
  `obsidian-nvim/obsidian.nvim` (config: `~/dev/lazyvim/lua/plugins/obsidian.lua`).
- Vault layout: `permanent/` (pattern/concept notes), `fleeting/` (quick
  captures/inbox), `projects/` (project-specific context, e.g. `cora/`),
  `daily/` (daily notes), `templates/`, `areas/`, `personal/`.
- New note IDs use a timestamp-slug format, e.g. `20260503000001-proxy-pattern.md`.
  Links use `[[wiki-link]]` style (shortest/basename form).
- When asked to create, file, or link notes, write Markdown files into the
  matching `~/work/notes` subdirectory following this layout and ID
  convention rather than inventing a different structure.

## Conventions

- Config changes for a tool live in this repo under a matching top-level
  directory (e.g. `zsh/`, `tmux/`, `starship/`) and are linked via the
  `[dotfiles]` table in `mise.toml` — don't edit files directly under `~`.
- After adding a new Nix package, update both the relevant `nix/*.nix` file
  and the corresponding table in `TOOLS.md` (and `README.md`'s "What Gets
  Installed" summary) in the same change.
