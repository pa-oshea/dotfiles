# dotfiles

![Desktop](./screenshots/desktop.png)

## Install

### zsh

```bash
chsh -s $(which zsh)
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
```

### [rust](https://www.rust-lang.org/)

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### [go](https://go.dev/)

##### [gvm](https://github.com/moovweb/gvm)

```bash
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
```

### [nvm](https://github.com/nvm-sh/nvm)

[Install](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating)

### [sdkman](https://sdkman.io/)

```bash
curl -s "https://get.sdkman.io" | bash
```

### [neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md)

[Build](https://github.com/neovim/neovim/blob/master/BUILD.md)

### [fzf](https://github.com/junegunn/fzf)

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### [starship](https://starship.rs/)

```bash
curl -sS https://starship.rs/install.sh | sh
```

### [zoxide](https://github.com/ajeetdsouza/zoxide)

```bash
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

```

### [lazygit](https://github.com/jesseduffield/lazygit)

```bash
go install github.com/jesseduffield/lazygit@latest
```

### [delta](https://github.com/dandavison/delta)

```bash
cargo install git-delta
```

```gitconfig
[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    navigate = true    # use n and N to move between diff sections
    light = false      # set to true if you're in a terminal w/ a light background color (e.g. the default macOS terminal)

[merge]
    conflictstyle = diff3

[diff]
    colorMoved = default
```

### [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy?tab=readme-ov-file#install)

#### Ubuntu

```bash
sudo add-apt-repository ppa:aos1/diff-so-fancy
sudo apt update
sudo apt install diff-so-fancy
```

#### Arch

```bash

yay diff-so-fancy
```

### [fd](https://github.com/sharkdp/fd)

```bash
cargo install fd-find
```

### [ripgrep](https://github.com/BurntSushi/ripgrep)

```bash
cargo install ripgrep
```

### [tmux](https://github.com/tmux/tmux/wiki/Installing)

| Platform         | Install Command     |
| ---------------- | ------------------- |
| Arch Linux       | pacman -S tmux      |
| Debian or Ubuntu | apt install tmux    |
| Fedora           | dnf install tmux    |
| RHEL or CentOS   | yum install tmux    |
| openSUSE         | zypper install tmux |

#### Dependencies

`autoconf, automake, pkg-config`

```bash
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make
```

### [tpm](https://github.com/tmux-plugins/tpm)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### [eza](https://github.com/eza-community/eza)

```bash
cargo install eza
```

### [navi](https://github.com/denisidoro/navi)

```bash
cargo install --locked navi
```

## TODO

- Audio
- notifications
- network manager
- settings manager xfce4
- polybar
- i3 lock screen
- requirements file

[Rofi themes](https://github.com/adi1090x/rofi)
[Polybar themes](https://github.com/adi1090x/polybar-themes)
