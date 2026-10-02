# CLI Tool Guide

A practical, "how do I actually use this" reference for every CLI tool
installed via Nix (see `nix/*.nix` for the authoritative install list). Where
an alias already exists in `zsh/.zshalias`, it's noted so you don't duplicate
muscle memory.

---

## File & Search

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **fd** | Fast, friendly `find` replacement | `fd pattern`, `fd -e md` (by extension), `fd -t d` (dirs only). Used under the hood by `fcd`/`ff` aliases and FZF defaults. |
| **ripgrep (rg)** | Fast recursive grep | `rg pattern`, `rg -i`, `rg -t py pattern`. Aliases: `rgf` (list files), `rgi`, `rgw`, `rgt`, `rgv`, `rgc`, `rgl`, `rgtodo`, `rgconf`. Config at `ripgrep/config`. |
| **bat** | `cat` with syntax highlighting + git gutter | `bat file.go`, `bat -A` (show non-printables), `bat -p` (plain, for piping). Config at `bat/config`. |
| **eza** | Modern `ls` replacement | Aliased as `ll`/`la`/`ls` (long, git status, icons) and `lt`/`lt2`/`lt3` (tree view). |
| **fzf** | Fuzzy finder, powers shell widgets | `Ctrl-R` (history), `Ctrl-T` (file insert), `Alt-C` (cd into dir). Also used by `fzf-tab` for completion menus and `fcd`/`ff`/`fkill`/`fenv`/`fh` aliases. |
| **zoxide** | Smarter `cd` that learns frecency | Aliased over `cd` itself (`cd foo` jumps to the best match after you've visited it once). `zoxide query -l` lists ranked dirs. |
| **tree** | Directory tree printer | `tree -L 2`. Prefer `lt`/`eza -T` day-to-day. |

## Text & Data

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **jq** | JSON query/transform | `curl ... \| jq .`, `jq '.items[].name'`. Alias: `pretty` (= `jq .`), `json` (= `fx`). |
| **yq-go** | YAML/JSON/XML query, jq-like syntax | `yq '.spec.containers[0].image' file.yaml`. Aliases: `yaml`, `prettyyml`. |
| **glow** | Render Markdown in the terminal | `glow README.md`, `glow -p file.md` (pager). Aliases: `md`, `readme`, `mdprev`. |
| **fx** | Interactive JSON viewer/explorer | `cat data.json \| fx` then navigate with arrow keys, `.` to drill in. Alias: `json`. |

## System Monitoring

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **bottom (btm)** | `top`/`htop` replacement, graphs | `btm`. Alias: `meminfo` (= `btm --memory`). |
| **btop** | Alternative resource monitor, mouse support | `btop`. |
| **dust** | Disk usage, visual tree | Aliased `dust` → `dust -r` (reversed, biggest first). Also `usage` (= `dust -d 1`, one level deep). |
| **procs** | Modern `ps` replacement | Aliased over `ps`. `procs --tree` for a process tree. |
| **fastfetch** | System info banner | Aliases: `sysinfo`, `neofetch`. |

## Network

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **httpie** | Human-friendly HTTP client | Aliased `http`/`https` with `--print=HhBb` (full request+response). `http POST api.site/x name=val`. |
| **netcat** | Raw TCP/UDP swiss-army knife | `nc -zv host port` (port check), `nc -l -p 1234` (listen). |

## Version Control

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **lazygit** | Terminal git UI | Alias `lg`. `space` to stage, `c` to commit, `P`/`p` to push/pull. Config at `lazygit/config.yml`. |
| **delta** | Syntax-highlighted diff pager | Wired into `.gitconfig` as the pager for `diff`/`log`/`show`/`blame`. Nothing to invoke directly — just use normal git commands. |
| **git-absorb** | Auto-fixup staged changes into the right prior commits | `git add -p` then `git absorb --and-rebase` (aliased `git absorb`). |
| **gh** | GitHub CLI | `gh pr create`/`gh pr list` (aliased `git pr`/`git prs`), `gh issue list`, `gh repo clone`. |
| **git-lfs** | Large file storage | `git lfs track "*.psd"`, `git lfs pull`. Already wired into `.gitconfig` filters. |

## Terminal & Multiplexers

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **tmux** | Terminal multiplexer | `tmux new -s name`, `Ctrl-b d` detach, `tmux a -t name` attach. Config at `tmux/tmux.conf`. |
| **tmux-sessionizer** | Fuzzy-jump to a tmux session per project dir | Bound as a tmux key in `tmux.conf`; search dirs are configured via **tms** (`tms/config.toml`: `~/work`, `~/dev`, `~/.dotfiles`). |
| **zellij** | Alternative terminal multiplexer, built-in layouts | `zellij` (new), `zellij a name` (attach), `zellij-session.zsh` provides a sessionizer similar to tmux's. Config at `zellij/config.kdl`, layouts in `zellij/layouts/`. |

## Editor

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **neovim** | Editor, `$EDITOR`/`$VISUAL` | `nvim file`. `zshconfig`/`zshenv`/`starconfig` aliases open specific dotfiles directly in it. |
| **luarocks / tree-sitter** | Neovim plugin ecosystem support | Used transparently by Neovim plugin managers/parsers — rarely invoked directly. |

## File Management

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **yazi** | Terminal file manager | Alias `fm`. `hjkl` to navigate, `Enter` to open, `y`/`p` yank/paste, `q` quit. Config in `yazi/`. |
| **rsync** | Fast file sync/copy | `rsync -avh --progress src/ dest/`. |

## Dev Workflow

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **direnv** | Per-directory env vars, auto-loaded | Add a `.envrc` to a project, run `direnv allow` once. |
| **just** | Command runner (Makefile alternative) | Aliases: `j` (run), `jl` (`--list`), `jr` (`--dry-run`). Define recipes in a `justfile`. |
| **gum** | Build interactive shell scripts/prompts | `gum choose a b c`, `gum confirm "proceed?"`. Mostly used inside scripts. |

## Analysis & Benchmarking

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **tokei** | Lines-of-code counter by language | Alias `loc`. |
| **hyperfine** | Statistically sound command benchmarking | Alias `bench`. `hyperfine 'cmd a' 'cmd b'` to compare. |
| **atac** | Terminal API client (Postman-like) | Alias `api`. |

## Containers & Kubernetes

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **dive** | Inspect Docker image layers | `dive image:tag`. |
| **lazydocker** | Terminal Docker UI | Alias `ld`. |
| **kubectl** | Kubernetes CLI | Alias `kube`. |
| **helm** | Kubernetes package manager | `helm install`, `helm upgrade`. |
| **k9s** | Terminal Kubernetes UI | Alias `k9`. |

Extra Docker aliases: `dps` (formatted `ps`), `dlogs`, `dexec`, `dimg`, `dsp` (stop-all + prune — careful!).

## Linting

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **shellcheck** | Shell script linter | Aliased with `-f gcc` for editor-friendly output. |
| **yamllint** | YAML linter | Aliased with `-f parsable`. |

## Database

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **sqlite** | Embedded SQL database | Aliases `sqlite`/`db` → `sqlite3`. |

## Help & Docs

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **tealdeer (tldr)** | Community-driven, example-first man pages | Aliased with `--color always`. `tldr tar`. |
| **navi** | Interactive cheat-sheet runner | Alias `cheat`. Browse/search snippets, fill placeholders, execute inline. |

## Utilities

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **entr** | Re-run a command when files change | Aliased `autorun` (= `entr -c`): `fd -e go \| autorun go test ./...`. |
| **parallel** | Run jobs in parallel from stdin | Aliased with `--will-cite`: `fd -e png \| parallel convert {} {.}.jpg`. |
| **watch** | Repeat a command on an interval | Intentionally **not** aliased (Nix's `-c` flag conflicts with system `watch`) — use the full command. |
| **unzip** | Archive extraction | `unzip file.zip`. |
| **stow** | GNU Stow (symlink farm manager) | Installed but no longer the active dotfiles manager — see `README.md`; kept around for ad-hoc manual symlinking if ever needed. |

## Prompt

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **starship** | Cross-shell prompt | Config at `starship/starship.toml` (theme: token-flint). Alias `starconfig` opens it. |

## Build Tools

| Tool | What it's for | Quick usage |
|------|----------------|-------------|
| **gcc / gnumake / pkg-config** | C toolchain, needed by some native Node/Rust/Neovim plugin builds | Rarely invoked directly — present so builds that shell out to `make`/`cc` succeed. |

## Zsh Plugins

Sourced directly from the Nix store in `zsh/.zshrc` — no plugin manager needed.

| Tool | What it's for |
|------|----------------|
| **zsh-autosuggestions** | Ghost-text suggestions from history as you type (`→` or `End` to accept). |
| **zsh-syntax-highlighting** | Colors valid/invalid commands as you type. |
| **zsh-completions** | Extra completion definitions for many CLIs. |
| **zsh-fzf-tab** | Replaces the default completion menu with an fzf-powered one (`Tab` to trigger, `<`/`>` to switch groups). |
| **zsh-forgit** | Interactive fzf UI for git (add/diff/log/stash/etc.) — try `ga`, `gd`, `glo`, `gss` once loaded. |

---

## Language-specific tool belts

These are installed on demand (`nix profile install ~/.dotfiles#<lang>`) —
see `README.md` → "What Gets Installed" for the full package list per
ecosystem. Highlights:

- **Java** (`nix/java.nix`): `google-java-format` (formatting), `checkstyle`/`spotbugs`/`pmd` (static analysis), `flyway`/`liquibase` (DB migrations), `spring-boot-cli` (scaffolding).
- **Go** (`nix/go.nix`): `golangci-lint`/`govulncheck` (lint/security), `gofumpt`/`goimports`/`golines` (format), `delve` (debugger), `air`/`modd` (live reload — `air` for hot-reloading servers during development).
- **Rust** (`nix/rust.nix`): `cargo-watch` (`cargo watch -x test`), `cargo-edit` (`cargo add`/`cargo rm`), `cargo-audit` (vulnerability scan), `cargo-expand` (macro expansion), `cargo-flamegraph` (profiling).
- **Node** (`nix/node.nix`): `prettier` (format), `npm-check-updates` (`ncu`, dependency bumps), `serve` (quick static file server).

Runtimes themselves (the actual `java`/`go`/`node`/`rust` binaries) come from
**mise**, not Nix — see `README.md` → "Runtime Management (mise)".
