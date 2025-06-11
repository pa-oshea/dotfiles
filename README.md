# dotfiles

![Desktop](./screenshots/desktop.png)

## 🚀 Quick Setup

```bash
# Clone the repository
git clone https://github.com/pa-oshea/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Make scripts executable
chmod +x install.sh scripts/*.sh

# One-command setup for new machines
./scripts/quick-setup.sh

# Or manual setup with specific languages
./scripts/install-nix.sh
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

## 🧪 Testing

### Docker Testing (Recommended)

Test the installation safely in disposable containers across different distributions:

#### Ubuntu/Debian Testing

```bash
# Ubuntu 22.04
docker run -it --rm ubuntu:22.04 bash -c "
  apt-get update && apt-get install -y git curl sudo xz-utils ca-certificates
  useradd -m -s /bin/bash testuser
  echo 'testuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
  sudo -u testuser bash -c 'cd && git clone https://github.com/pa-oshea/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./scripts/quick-setup.sh'
"
```

#### Fedora Testing

```bash
# Fedora Latest
docker run -it --rm fedora:latest bash -c "
  dnf install -y git curl sudo xz ca-certificates
  useradd -m -s /bin/bash testuser
  echo 'testuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
  sudo -u testuser bash -c 'cd && git clone https://github.com/pa-oshea/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./scripts/quick-setup.sh'
"
```

#### Arch Linux Testing

```bash
# Arch Linux Latest
docker run -it --rm archlinux:latest bash -c "
  pacman -Sy --noconfirm git curl sudo xz ca-certificates
  useradd -m -s /bin/bash testuser
  echo 'testuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
  sudo -u testuser bash -c 'cd && git clone https://github.com/pa-oshea/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./scripts/quick-setup.sh'
"
```

#### Step-by-step testing (any distro)

```bash
# 1. Start container (replace with your preferred distro)
docker run -it --rm ubuntu:22.04 bash

# 2. Install dependencies (adjust package manager)
# Ubuntu/Debian:
apt-get update && apt-get install -y git curl sudo xz-utils ca-certificates

# Fedora
# dnf install -y git curl sudo xz ca-certificates

# Arch:
# pacman -Sy --noconfirm git curl sudo xz ca-certificates

# 3. Create user with passwordless sudo
useradd -m -s /bin/bash testuser
echo 'testuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# 4. Switch to test user
su - testuser

# 5. Clone and test dotfiles
git clone https://github.com/pa-oshea/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/quick-setup.sh
```

#### Test different scenarios

```bash
# Test dry run
./install.sh --dry-run --languages rust python

# Test with backup
./install.sh --backup --languages node

# Test specific languages
./install.sh --languages rust go java

# Test minimal installation
./install.sh

# Test full installation with all languages
./install.sh --languages rust node python go java
```

### Other Testing Options

#### Virtual Machine (Vagrant)

```bash
# Create test directory
mkdir ~/dotfiles-vagrant-test
cd ~/dotfiles-vagrant-test

# Test Ubuntu 22.04
cp ~/.dotfiles/vagrant/Vagrantfile.ubuntu22 Vagrantfile 
vagrant up
vagrant ssh
# Test your dotfiles, then exit

# Destroy and test Fedora
vagrant destroy -f
cp Vagrantfile.fedora Vagrantfile 
vagrant up
vagrant ssh
# Test your dotfiles

# And so on for each distro...
# Then:
vagrant up
vagrant ssh

# Inside the VM:
cd ~/.dotfiles
./scripts/quick-setup.sh
```

### What Gets Tested

- ✅ Nix package manager installation across distributions
- ✅ Core CLI tools (zsh, fzf, ripgrep, bat, etc.)
- ✅ Development tools (git, tmux, neovim, docker)
- ✅ Language-specific tooling (optional)
- ✅ Shell configuration and symlinks
- ✅ Package manager compatibility (apt, dnf, pacman)
- ✅ Error handling and recovery

### Troubleshooting Tests

If installation fails, check:

```bash
# Verify Nix installation
nix --version

# Check installed packages
nix-env -q

# View installation logs
./install.sh --dry-run

# Test specific distribution dependencies
# Ubuntu/Debian: apt list --installed | grep -E "(git|curl|xz)"
# Fedora: dnf list installed | grep -E "(git|curl|xz)"
# Arch: pacman -Q | grep -E "(git|curl|xz)"

# Rollback if needed
nix-env --rollback
```

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
