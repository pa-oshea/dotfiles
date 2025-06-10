# dotfiles

![Desktop](./screenshots/desktop.png)

## 🚀 Quick Setup

```bash
# Clone the repository
git clone https://github.com/pa-oshea/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

chmod +x scripts/*.sh

# One-command setup for new machines
./scripts/quick-setup.sh

# Or manual setup
./install-nix.sh
./install.sh --languages rust node python go java
```

## 🎯 Installation

### Core

``` bash
./install.sh
```

### With Languages

```bash
./install.sh --languages rust node python go java
```

Development profile + language-specific tooling

## 🔧 Usage Examples

### Install Specific Package Sets

```bash
# Core tools only
nix-env -if ~/.dotfiles/nix/packages/core.nix

# Add language-specific tools
nix-env -if ~/.dotfiles/nix/packages/languages/rust.nix
nix-env -if ~/.dotfiles/nix/packages/languages/java.nix
```

### Language Runtime Management

```bash
# Use mise for runtime versions
mise install node@20.10.0
mise install python@3.12.0
mise install go@1.21.5
mise install rust@1.75.0

# Use SDKMAN for Java
sdk install java 21.0.1-tem
sdk install java 17.0.9-tem
sdk use java 21.0.1-tem
```

### Maintenance

```bash
# Update everything
./scripts/update-all.sh

# Update with system packages
./scripts/update-all.sh --system

# Preview updates
./scripts/update-all.sh --dry-run
```

### Override Settings

## 📚 Quick Commands

```bash
# Package management
nix-env -q                     # List installed packages
nix-env -e package-name        # Remove package
nix-env --rollback            # Rollback changes
nix-collect-garbage           # Clean up old packages

# Language management
mise list                     # Show installed runtimes
mise install node@latest     # Install latest Node.js
sdk list java                # Show available Java versions

# System maintenance
./scripts/update-all.sh       # Update everything
tmux-sessionizer             # Quick project switching
```

## 🆘 Troubleshooting

### Nix Issues

```bash
# Reinstall Nix
./scripts/install-nix.sh uninstall
./scripts/install-nix.sh install

# Reset packages
nix-env --rollback
```

### Shell Issues

```bash
# Reload configuration
source ~/.zshrc

# Reinstall plugins
rm -rf ~/.oh-my-zsh/custom/plugins/*
./install.sh dev
```

---

**One command to rule them all**: `./scripts/quick-setup.sh` 🚀

---

## 🔨 Manual Installation Reference

### Configuration Linking

```bash
# Link configuration directories
ln -sf ~/.dotfiles/dunst ~/.config/
ln -sf ~/.dotfiles/i3 ~/.config/
ln -sf ~/.dotfiles/kitty ~/.config/
ln -sf ~/.dotfiles/picom ~/.config/
ln -sf ~/.dotfiles/polybar ~/.config/
ln -sf ~/.dotfiles/rofi ~/.config/
ln -sf ~/.dotfiles/zsh ~/.config/
ln -sf ~/.dotfiles/tmux ~/.config/

# Link dotfiles
ln -sf ~/.dotfiles/.zshenv ~/
ln -sf ~/.dotfiles/.gitconfig ~/

# Install scripts
ln -sf ~/.dotfiles/scripts/tmux-sessionizer.sh ~/.local/bin/tmux-sessionizer

# Install fonts
mkdir -p ~/.local/share/fonts
cp ~/.dotfiles/fonts/* ~/.local/share/fonts/
fc-cache -fv
```

### Core Tools Installation

#### Nix Package Manager

```bash
# Install Nix (single-user)
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# Install essential packages
# Check core.nix for missing packages
nix-env -iA \
  nixpkgs.git \
  nixpkgs.zsh \
  nixpkgs.neovim \
  nixpkgs.tmux \
  nixpkgs.fzf \
  nixpkgs.lazygit \
  nixpkgs.ast-grep \
  nixpkgs.lazydocker \
  nixpkgs.neofetch \
  nixpkgs.jq \
  nixpkgs.delta \
  nixpkgs.ripgrep \
  nixpkgs.fd \
  nixpkgs.eza \
  nixpkgs.tokei \
  nixpkgs.atac \
  nixpkgs.yazi \
  nixpkgs.bat \
  nixpkgs.xsel \
  nixpkgs.lsd \
  nixpkgs.tldr
```

#### Shell Setup

```bash
# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Zsh plugins
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Set Zsh as default shell
chsh -s $(which zsh)
```

#### Terminal Enhancements

```bash
# Starship prompt
curl -sS https://starship.rs/install.sh | sh

# Zoxide (smart cd)
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# FZF (if not installed via Nix)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Development Tools

#### Language Runtimes

```bash
# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# SDKMAN (Java, Kotlin, Scala, etc.)
curl -s "https://get.sdkman.io" | bash

# Node Version Manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

#### Development Tools (Go-based)

```bash
# Ensure Go is installed, then:
go install github.com/jesseduffield/lazygit@latest
go install github.com/jesseduffield/lazydocker@latest
```

### Tmux Setup

#### System Installation

| Platform         | Install Command     |
| ---------------- | ------------------- |
| Arch Linux       | `pacman -S tmux`    |
| Debian/Ubuntu    | `apt install tmux`  |
| Fedora           | `dnf install tmux`  |
| RHEL/CentOS      | `yum install tmux`  |
| openSUSE         | `zypper install tmux` |
| macOS            | `brew install tmux` |

#### Plugin Manager

```bash
# Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

#### Building from Source (if needed)

```bash
# Install dependencies first (varies by system)
# Ubuntu/Debian: apt install libevent-dev ncurses-dev build-essential bison pkg-config
# Fedora: dnf install libevent-devel ncurses-devel gcc make bison

git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make
sudo make install
```

### Neovim Setup

For the latest Neovim, refer to the [official installation guide](https://github.com/neovim/neovim/blob/master/INSTALL.md).

#### Building from Source

```bash
# Install dependencies (Ubuntu/Debian example)
sudo apt install ninja-build gettext cmake unzip curl

git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
```
