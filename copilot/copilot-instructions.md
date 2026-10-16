# Global Copilot Instructions

This file is symlinked to `~/.copilot/copilot-instructions.md` and applies to
every GitHub Copilot CLI session on this machine, regardless of repository.

## Environment

- OS: Linux. Shell: zsh (`zsh/.zshrc`), prompt via starship.
- Dotfiles are managed declaratively from `~/.dotfiles` and linked into `~`
  via `mise dotfiles link` (see `~/.dotfiles/mise.toml`'s `[dotfiles]` table).
  Do not suggest GNU Stow — it's no longer the active dotfiles manager.
- `~/dev/` contains my lazyvim config.
- `~/work/` contains all work related projects in development.
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
  - Use it for convention sweeps in Java repos, e.g. (`-l java`):
    `$R.findById($$$).orElseThrow($$$)` (Finder rule),
    `@Autowired` fields, `REQUIRES_NEW` near outbox code,
    `@Transactional` on private methods, `new RestTemplate($$$)`.
    Preview rewrites with `ast-grep run -p ... -r ...` before applying `-U`.
- `jq`/`yq-go` for JSON/YAML, `visidata` for exploring tabular/CSV data
- `lnav` for multi-file/log analysis instead of manual `tail`/`grep` chains
- `kubectl`/`oc` (OpenShift) for Kubernetes work, `stern` for multi-pod log
  tailing, `kubectx`/`kubens` for cluster/namespace switching
- `lazygit` for interactive git staging/review when a TUI helps
- `atuin` provides shell history search (`Ctrl-R`); history sync is not
  configured, it is local-only
- `tokei` for LOC/language breakdown, `dust` for disk usage, `procs` for
  process listing, `tldr` for quick command examples
- `http` (httpie) or `curl` for ad-hoc API calls; `gh` for all GitHub work
- `just` for project command recipes when a `justfile` exists; `entr` to
  re-run on change, `parallel` for fan-out jobs, `hyperfine` to benchmark
- `git absorb` for fixing up earlier commits; `delta` is already the git pager
- `shellcheck` for shell scripts, `yamllint` for YAML, and the language
  tools from `nix/*.nix` (e.g. `prettier`, `google-java-format`, `gofumpt`,
  `golangci-lint`, `cargo-audit`, `flyway`) rather than hand-formatting

### Code search rules (strict)

- For any code sweep (usage audits, convention checks, "is X still used?",
  pre-removal checks, migrations) use `rg` for text and `ast-grep` for
  syntax-aware patterns. Never use plain `grep`/`find`.
- Never chain `grep | grep` to correlate things on the same line: it misses
  multi-line matches (e.g. multi-line imports). Search the identifier alone
  with `rg '\bname\b'`, or use an `ast-grep` pattern like `name($$$)`.
- Prefer `ast-grep` whenever precision matters: call sites vs. comments or
  strings, imports, decorators/annotations, structural refactors. Verify the
  sweep returns zero hits before declaring a removal/migration complete.

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
- Suggest to create new notes that might be relevant.

## Agent workflow

- Use git worktrees to your advantage when it makes sense: e.g. parallel
  independent workstreams (background agents, exploring an alternative
  approach, running a long build/test while continuing other edits) that
  would otherwise conflict over the same working directory or require
  stashing. Prefer `/worktree` (new branch off the configured base ref) or
  `/fork worktree` (preserve current session context) over manually running
  `git worktree add`.
- Don't reach for a worktree for simple sequential edits in one repo — only
  when true parallelism or isolation is needed (e.g. comparing two branches,
  testing a risky refactor side-by-side with the current work, or letting a
  background agent run without touching the primary working tree).

## Conventions

- Config changes for a tool live in this repo under a matching top-level
  directory (e.g. `zsh/`, `tmux/`, `starship/`) and are linked via the
  `[dotfiles]` table in `mise.toml` — don't edit files directly under `~`.
- After adding a new Nix package, update both the relevant `nix/*.nix` file
  and the corresponding table in `TOOLS.md` (and `README.md`'s "What Gets
  Installed" summary) in the same change.
- Follow YAGNI principles. Before removing a dependency or "dead" code, verify
  real usage with a grep of imports/references across all modules.
- Prefer an existing library call over hand-written helpers (e.g. commons-lang3
  `StringUtils`) — less code to maintain.

## Git etiquette

- Never commit, push, force-push or open a PR unless I explicitly say so.
  "Put it into one commit" / "commit now" counts as explicit; finishing a task
  does not.
- Never delete tracked docs/scripts (`*.md`, `justfile`, `Makefile`) as part of
  a cleanup unless asked. Mention them instead.
- When asked to split work into PRs, use separate branches/worktrees per
  concern (e.g. library migration vs. general cleanup) and verify each builds
  and tests green on its own.
- Commit messages from Copilot end with the `Co-authored-by: Copilot` trailer.
