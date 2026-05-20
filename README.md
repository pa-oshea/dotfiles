# dotfiles

Personal development environment for Linux. Nix manages CLI tools
declaratively. Language runtimes are handled by **mise** (Java, Go, Node, Rust).

---

## Architecture

```
Layer           Tool        Manages
──────────────────────────────────────────────────────────────────
System          pacman      git, base-devel, OS-level deps
CLI Tools       Nix         neovim, tmux, zellij, ripgrep, etc.
All runtimes    mise        Java, Go, Node, Rust — per-project
Config/dots     stow        symlinks from ~/.dotfiles into ~
```

Nix tools live in `/nix/store` and never touch system paths. Each layer owns
a distinct concern and they don't interfere with each other.

**mise is intentionally NOT installed via Nix.** It must be installed via the
curl installer so its shims directory (`~/.local/share/mise/shims`) is properly
activated by the shell and visible to all processes including Neovim/Mason.

The Nix setup is **declarative**: `flake.nix` defines what to install,
`flake.lock` pins exact versions. One command installs everything identically
on every machine.

---

## Symlinking (link.sh)

`scripts/link.sh` creates all symlinks from the repo into `~`. The repo
structure mirrors `~` exactly — `.config/` and `.local/` prefixes are
preserved so everything lands in the right place.

```bash
# Preview what will be linked (no changes made)
bash ~/.dotfiles/scripts/link.sh --dry-run

# Apply
bash ~/.dotfiles/scripts/link.sh
```

The script handles existing files safely — it backs them up with a timestamp
before replacing them, and skips anything already correctly linked. Scripts
under `.local/bin/` are made executable automatically.

To add a new config to the repo: put it at the correct mirrored path, add a
`link` line to `scripts/link.sh`, and re-run the script.

---

## Repository Structure

TODO: The repo mirrors `~` exactly so stow works correctly:

```
~/.dotfiles/
├── flake.nix                        # Nix packages — source of truth
├── flake.lock                       # Pins exact nixpkgs versions — always commit
├── nix/
│   ├── core.nix                     # Universal CLI tools
│   ├── java.nix                     # Java ecosystem tools
│   ├── go.nix                       # Go ecosystem tools
│   ├── rust.nix                     # Rust/cargo tools
│   └── node.nix                     # Node ecosystem tools
├── .zshenv                          # → ~/.zshenv (sets ZDOTDIR, loaded first)
├── .config/
│   ├── zsh/
│   │   ├── .zshenv                  # → ~/.config/zsh/.zshenv
│   │   ├── .zshrc                   # → ~/.config/zsh/.zshrc
│   │   ├── .zshalias                # → ~/.config/zsh/.zshalias
│   │   └── .zshfunc                 # → ~/.config/zsh/.zshfunc
│   ├── tmux/
│   │   └── tmux.conf                # → ~/.config/tmux/tmux.conf
│   ├── starship/
│   │   └── starship.toml            # → ~/.config/starship/starship.toml
│   ├── yazi/
│   │   ├── keymap.toml              # → ~/.config/yazi/keymap.toml
│   │   ├── theme.toml               # → ~/.config/yazi/theme.toml
│   │   └── yazi.toml                # → ~/.config/yazi/yazi.toml
│   ├── ripgrep/
│   │   └── config                   # → ~/.config/ripgrep/config
│   └── mise/
│       └── config.toml              # → ~/.config/mise/config.toml
└── .local/
    └── bin/
        ├── tmux-sessionizer.sh      # → ~/.local/bin/tmux-sessionizer.sh
        └── tmux-status-info.sh      # → ~/.local/bin/tmux-status-info.sh
```

> **Note:** `nix/` and `flake.*` are not stowed — they are only used by
> `nix profile install` and never symlinked into `~`.

---

## New Machine Bootstrap

Order matters — mise must be in place before dotfiles are linked, Nix last.

```bash
# 1. Install Nix (Determinate installer)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. Restart your shell

# 3. Install mise (must be via curl, NOT via Nix)
curl https://mise.run | sh

# 4. Clone dotfiles
git clone https://github.com/pa-oshea/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 5. Dry run first — preview what will be linked
bash ~/.dotfiles/scripts/link.sh --dry-run

# 6. Link dotfiles (backs up any existing files automatically)
bash ~/.dotfiles/scripts/link.sh

# 7. Verify symlinks are correct
ls -la ~/.zshenv ~/.config/zsh/.zshrc ~/.config/tmux/tmux.conf

# 8. Install Nix tools
nix profile install ~/.dotfiles#core
# Add language tooling as needed:
nix profile install ~/.dotfiles#java
nix profile install ~/.dotfiles#go
nix profile install ~/.dotfiles#node
nix profile install ~/.dotfiles#rust

# 9. Install runtimes via mise (reads ~/.config/mise/config.toml)
mise install

# 10. Restart shell — everything should be available
```

---

## What Gets Installed

### Core (`nix/core.nix`)

| Category         | Tools                                                        |
|------------------|--------------------------------------------------------------|
| Shell            | starship, zoxide                                             |
| File & Search    | fd, ripgrep, bat, eza, fzf, yazi, tree                      |
| Text & Data      | jq, yq-go, glow, fx                                         |
| Monitoring       | bottom, btop, dust, procs, fastfetch                         |
| Network          | httpie, netcat                                               |
| VCS              | lazygit, delta, git-absorb, gh, git-lfs                      |
| Editor           | neovim, luarocks                                             |
| Terminal         | tmux, zellij                                                 |
| Dev workflow     | direnv, just, gum                                            |
| Analysis         | tokei, hyperfine, atac                                       |
| Containers       | dive, lazydocker, kubectl, helm, k9s                         |
| Linting          | shellcheck, yamllint                                         |
| Clipboard        | wl-clipboard (Wayland)                                       |
| Docs             | tealdeer, navi                                               |
| Utilities        | watch, entr, parallel, rsync, unzip, stow                    |
| Zsh plugins      | zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions, zsh-fzf-tab |

### Language Tooling

Ecosystem CLIs and static analysis only — runtimes come from mise.

| Package | Command                                | What's included |
|---------|----------------------------------------|-----------------|
| `java`  | `nix profile install ~/.dotfiles#java` | google-java-format, checkstyle, spotbugs, pmd, plantuml, flyway, liquibase, spring-boot-cli, coursier |
| `go`    | `nix profile install ~/.dotfiles#go`   | golangci-lint, govulncheck, gofumpt, goimports, golines, gotests, goreleaser, delve, air, modd |
| `rust`  | `nix profile install ~/.dotfiles#rust` | cargo-watch, cargo-edit, cargo-outdated, cargo-audit, cargo-expand, cargo-bloat, cargo-flamegraph, wasm-pack, mdbook |
| `node`  | `nix profile install ~/.dotfiles#node` | prettier, npm-check-updates, serve |

---

## Runtime Management (mise)

All language runtimes are managed by mise. `~/.config/mise/config.toml` is
symlinked from this repo, so `mise install` restores everything in one command.

```bash
# Install everything defined in config.toml
mise install

# Set global defaults
mise use --global java@latest
mise use --global java@21
mise use --global go@latest
mise use --global node@lts
mise use --global rust@latest

# Pin a project to specific versions (writes .mise.toml in project root)
cd ~/your-project
mise use java@17
mise use node@20

# Useful commands
mise list                           # show installed runtimes
mise current                        # show active versions in current dir
mise upgrade                        # upgrade all runtimes
```

### Multiple Java versions

Pin per-project via `.mise.toml` in the project root:

```toml
[tools]
java = "17"
```

For jdtls (Neovim LSP), configure the runtime JDK separately from the project
JDK so jdtls always runs on Java 21+ regardless of project:

```lua
-- In your jdtls Neovim config
cmd = {
  vim.fn.expand("~/.local/share/mise/installs/java/21/bin/java"),
  -- ...
},
settings = {
  java = {
    configuration = {
      runtimes = {
        { name = "JavaSE-17",     path = vim.fn.expand("~/.local/share/mise/installs/java/17") },
        { name = "JavaSE-21",     path = vim.fn.expand("~/.local/share/mise/installs/java/21") },
        { name = "JavaSE-latest", path = vim.fn.expand("~/.local/share/mise/installs/java/latest") },
      }
    }
  }
}
```

---

## Maintenance

```bash
# Update flake.lock to latest nixpkgs (commit the result)
nix flake update ~/.dotfiles

# Apply updates to your Nix profile
nix profile upgrade '.*'

# See what's currently installed
nix profile list

# Roll back if something breaks
nix profile rollback

# Free disk space
nix-collect-garbage -d

# Update mise runtimes
mise upgrade

# Re-link dotfiles after adding new files to the repo
cd ~/.dotfiles && stow --no-folding -R .

# 1. Update the lock file
nix flake update ~/.dotfiles

# 2. Re-install from the flake (this actually respects flake.lock)
nix profile install ~/.dotfiles#core

# Commit the updated lock file
cd ~/.dotfiles && git add flake.lock && git commit -m "chore: update nixpkgs"
```

---

## Troubleshooting

```bash
# Check what Nix has installed
nix profile list

# Roll back last Nix change
nix profile rollback

# Verify a tool is coming from Nix (not system)
which lazygit && lazygit --version

# Check mise runtimes
mise list

# Check active versions in current directory
mise current

# Verify a symlink is correct
ls -la ~/.config/zsh/.zshrc        # should point into ~/.dotfiles

# Reload shell config
source $ZDOTDIR/.zshrc
```

