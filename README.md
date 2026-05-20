
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

## New Machine Bootstrap

Order matters — mise must be in place before dotfiles are linked, Nix last.

```bash
# 1. Install Nix (Determinate installer)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. Restart shell

# 3. Install mise (must be via curl, NOT via Nix)
curl https://mise.run | sh

# 4. Clone dotfiles
git clone https://github.com/pa-oshea/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 5. Link dotfiles (stow mirrors ~/.dotfiles into ~)
stow .

# 6. Install Nix tools from the flake
#    Core tools only:
nix profile install ~/.dotfiles#core
#    Add language ecosystem tooling as needed:
nix profile install ~/.dotfiles#java
nix profile install ~/.dotfiles#go
nix profile install ~/.dotfiles#node
nix profile install ~/.dotfiles#rust

# 7. Install runtimes via mise (reads ~/.config/mise/config.toml)
mise install

# 8. Restart shell — everything should be available
```

---

## What Gets Installed

### Core (`nix/core.nix`)

| Category         | Tools                                                        |
|------------------|--------------------------------------------------------------|
| Shell            | starship, zoxide                                             |
| File & Search    | fd, ripgrep, bat, eza, fzf, yazi, tree                      |
| Text & Data      | jq, yq-go, glow, fx                                          |
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

These install ecosystem CLIs and static analysis tools. Runtimes themselves
are managed by mise (see Runtime Management below).

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
# Install runtimes
mise install                        # install everything in config.toml

# Set global defaults
mise use --global java@latest
mise use --global java@21
mise use --global go@latest
mise use --global node@lts
mise use --global rust@latest

# Pin a project to specific versions (writes .mise.toml in project root)
mise use java@17
mise use node@20

# Useful commands
mise list                           # show installed runtimes
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
-- In jdtls config
cmd = {
  vim.fn.expand("~/.local/share/mise/installs/java/21/bin/java"),
  -- ...
},
settings = {
  java = {
    configuration = {
      runtimes = {
        { name = "JavaSE-17",   path = vim.fn.expand("~/.local/share/mise/installs/java/17") },
        { name = "JavaSE-21",   path = vim.fn.expand("~/.local/share/mise/installs/java/21") },
        { name = "JavaSE-latest", path = vim.fn.expand("~/.local/share/mise/installs/java/latest") },
      }
    }
  }
}
```

### Neovim / Mason PATH

If Neovim is launched as a GUI app (not from a terminal), it won't inherit
the shell PATH and Mason installers will fail. Add this near the top of
`init.lua` to ensure mise shims are always visible:

```lua
vim.env.PATH = os.getenv("HOME") .. "/.local/share/mise/shims:" .. vim.env.PATH
```

---

## Maintenance

```bash
# Update flake.lock to latest nixpkgs (commit the result)
nix flake update ~/.dotfiles

# Apply updates to Nix profile
nix profile upgrade '.*'

# See what's installed
nix profile list

# Roll back if something breaks
nix profile rollback

# Free disk space
nix-collect-garbage -d

# Update mise runtimes
mise upgrade
```

---

## Troubleshooting

```bash
# Check what Nix has installed
nix profile list

# Roll back last Nix change
nix profile rollback

# Verify a tool is coming from Nix
which lazygit && lazygit --version

# Check mise runtimes
mise list

# Check active versions in current directory
mise current

# Reload shell config
source $ZDOTDIR/.zshrc
```

