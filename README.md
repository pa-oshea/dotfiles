# dotfiles

Personal development environment for Linux. Nix manages CLI tools declaratively.
Language runtimes are handled by **sdkman** (Java) and **mise** (Go, Node, Rust).

---

## Architecture

```
Layer           Tool        Manages
──────────────────────────────────────────────────────
System          pacman      git, base-devel, OS-level deps
CLI Tools       Nix         ripgrep, neovim, tmux, lazygit, etc.
Java runtimes   sdkman      JDK 21, 17, 11 — switchable per project
Other runtimes  mise        Go, Node, Rust — version-pinned per project
Config/dots     stow        symlinks from ~/.dotfiles into ~
```

Nix tools live in `/nix/store` and never touch system paths. Each layer owns
a distinct concern and they don't interfere with each other.

The Nix setup is **declarative**: `flake.nix` defines what to install,
`flake.lock` pins exact versions. One command installs everything identically
on every machine.

---

## New Machine Bootstrap

Order matters — sdkman and mise must be in place before the shell loads your
dotfiles, and Nix last so the profile is clean before you populate it.

```bash
# 1. Install Nix (Determinate installer — enables flakes, handles multi-user,
#    provides a clean uninstaller)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. Restart your shell (or open a new terminal)

# 3. Install sdkman
curl -s "https://get.sdkman.io" | bash
source "$HOME/.local/share/sdkman/bin/sdkman-init.sh"
sdk install java 21.0.3-tem

# 4. Install mise
curl https://mise.run | sh
# mise will activate via your shell config after dotfiles are linked

# 5. Clone dotfiles
git clone https://github.com/pa-oshea/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 6. Link dotfiles (stow reads the repo as a mirror of ~)
stow .

# 7. Install Nix tools from the flake
#    Core tools only:
nix profile install ~/.dotfiles#core
#    Core + language tooling (pick what you need):
nix profile install ~/.dotfiles#java
nix profile install ~/.dotfiles#go

# 8. Install mise runtimes (reads ~/.config/mise/config.toml)
mise install

# 9. Restart shell — everything should be available
```

---

## What Gets Installed

### Core (`nix/core.nix`)

| Category         | Tools                                          |
|------------------|------------------------------------------------|
| Shell            | starship, zoxide                               |
| File & Search    | fd, ripgrep, bat, eza, fzf, yazi, tree         |
| Text & Data      | jq, yq-go, glow, fx                            |
| Monitoring       | bottom, btop, dust, procs, fastfetch           |
| Network          | httpie, netcat                                 |
| VCS              | lazygit, delta, git-absorb, gh, git-lfs        |
| Editor           | neovim, luarocks                               |
| Terminal         | tmux                                           |
| Dev workflow     | direnv, just, mise, gum                        |
| Analysis         | tokei, hyperfine, atac                         |
| Containers       | dive, lazydocker, kubectl, helm, k9s           |
| Linting          | shellcheck, yamllint                           |
| Docs             | tealdeer, navi                                 |
| Zsh plugins      | zsh-autosuggestions, zsh-syntax-highlighting, fzf-tab, zsh-completions |
| Utilities        | watch, entr, parallel, rsync, unzip            |

### Language Tooling

These install ecosystem CLIs and static analysis tools — not the runtimes
themselves (those are managed by sdkman/mise).

| Package   | Command                                | What's included |
|-----------|----------------------------------------|-----------------|
| `java`    | `nix profile install ~/.dotfiles#java` | google-java-format, checkstyle, spotbugs, pmd, plantuml, flyway, liquibase, spring-boot-cli, coursier |
| `go`      | `nix profile install ~/.dotfiles#go`   | golangci-lint, govulncheck, gofumpt, goimports, golines, gotests, goreleaser, delve, air, modd |
| `rust`    | `nix profile install ~/.dotfiles#rust` | cargo-watch, cargo-edit, cargo-outdated, cargo-audit, cargo-expand, cargo-bloat, cargo-flamegraph, wasm-pack, mdbook |
| `node`    | `nix profile install ~/.dotfiles#node` | prettier, npm-check-updates, serve |
| `default` | `nix profile install ~/.dotfiles`      | Everything above combined |

---

## Runtime Management

### Java — sdkman

```bash
sdk install java 21.0.3-tem     # install a JDK
sdk install java 17.0.11-tem
sdk use java 21.0.3-tem         # switch for current session
sdk default java 21.0.3-tem     # set global default
sdk list java                   # browse available versions
```

Pin a project to a specific JDK with `.sdkmanrc` in the project root:

```ini
java=21.0.3-tem
```

Run `sdk env` inside the project to activate it.

### Go / Node / Rust — mise

```bash
mise use --global node@22       # set global default
mise use --global go@1.22
mise use node@20                # pin current project (writes .mise.toml)
mise list                       # show installed runtimes
mise upgrade                    # upgrade all runtimes
```

`~/.config/mise/config.toml` is symlinked from this repo, so `mise install`
on a new machine restores your global runtime versions in one command.

---

## Maintenance

```bash
# Update flake.lock to latest nixpkgs (then commit flake.lock)
nix flake update ~/.dotfiles

# Apply updates to your profile
nix profile upgrade '.*'

# See what's currently installed
nix profile list

# Roll back if something breaks
nix profile rollback

# Clean up old generations (free disk space)
nix-collect-garbage -d

# Update mise runtimes
mise upgrade

# Update sdkman itself + Java
sdk selfupdate
sdk upgrade java
```

---

## Testing in Docker

Test the install in a throwaway container before deploying to a real machine.

### Arch (closest to CachyOS)

```bash
docker run -it --rm archlinux:latest bash -c "
  pacman -Sy --noconfirm git curl sudo xz ca-certificates
  useradd -m -s /bin/bash testuser
  echo 'testuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
  sudo -u testuser bash -c '
    cd ~
    git clone https://github.com/pa-oshea/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    # Follow bootstrap steps manually
  '
"
```

### Ubuntu

```bash
docker run -it --rm ubuntu:22.04 bash -c "
  apt-get update && apt-get install -y git curl sudo xz-utils ca-certificates
  useradd -m -s /bin/bash testuser
  echo 'testuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
  sudo -u testuser bash -c '
    cd ~
    git clone https://github.com/pa-oshea/dotfiles.git ~/.dotfiles
  '
"
```

### Step-by-step

```bash
# Nix won't install as root — always test as a regular user
docker run -it --rm archlinux:latest bash
useradd -m -s /bin/bash testuser
echo 'testuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
su - testuser

# Then follow the New Machine Bootstrap steps above
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

# Check active Java
sdk current java

# Reload shell config
source ~/.zshrc
```

---

## Repository Structure

```
~/.dotfiles/
├── flake.nix           # Declares all Nix packages — the source of truth
├── flake.lock          # Pins exact nixpkgs versions — always commit this
├── nix/
│   ├── core.nix        # Universal CLI tools (installed on every machine)
│   ├── java.nix        # Java ecosystem tools
│   ├── go.nix          # Go ecosystem tools
│   ├── rust.nix        # Rust/cargo tools
│   └── node.nix        # Node ecosystem tools
├── shells/
│   ├── rust.nix        # Per-project devShell (gcc, openssl, pkg-config)
│   └── java.nix        # Per-project devShell (jmeter, visualvm)
├── zsh/
│   ├── .zshenv         # Environment, PATH, tool homes (loaded always)
│   └── .zshrc          # Interactive config, plugins, prompt
├── tmux/
├── neovim/
└── scripts/
    └── update-all.sh
```
