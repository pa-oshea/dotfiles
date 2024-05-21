# dotfiles

![Desktop](./screenshots/desktop.png)

## Linking

```
ln -s -r dunst ~/.config &
ln -s -r i3 ~/.config &
ln -s -r kitty ~/.config &
ln -s -r picom ~/.config &
ln -s -r polybar ~/.config &
ln -s -r rofi ~/.config &
ln -s -r zsh ~/.config &
ln -s -r .zshenv ~ &
ln -s -r .gitconfig ~ &
ln -s -r .tmux.conf ~ &
ln -s -r scripts/tmux-sessionizer.sh ~/.local/bin/ &
mv fonts/* ~/.local/share/fonts/
```

## Install

### zsh

```bash
chsh -s $(which zsh)
```

### [rust](https://www.rust-lang.org/)

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

#### Cargo packages

- [delta](https://github.com/dandavison/delta)
- [fd](https://github.com/sharkdp/fd)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [eza](https://github.com/eza-community/eza)
- [tokei](https://github.com/XAMPPRocky/tokei)
- [navi](https://github.com/denisidoro/navi)

```bash
cargo install git-delta fd-find ripgrep eza tokei
```

```bash
cargo install --locked navi
```

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

## TODO

- Audio
- notifications
- network manager
- settings manager xfce4
- i3 lock screen

[Rofi themes](https://github.com/adi1090x/rofi)
[Polybar themes](https://github.com/adi1090x/polybar-themes)
