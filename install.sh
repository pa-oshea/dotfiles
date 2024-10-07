#!/bin/bash

# Function to create symbolic links for dotfiles
link_dotfiles() {
    echo "Linking dotfiles..."

    # Array of directories and files to link
    declare -A dotfiles=(
        ["dunst"]="$HOME/.config"
        ["i3"]="$HOME/.config"
        ["kitty"]="$HOME/.config"
        ["picom"]="$HOME/.config"
        ["polybar"]="$HOME/.config"
        ["rofi"]="$HOME/.config"
        ["zsh"]="$HOME/.config"
        [".zshenv"]="$HOME"
        [".gitconfig"]="$HOME"
        [".tmux.conf"]="$HOME"
        ["scripts/tmux-sessionizer.sh"]="$HOME/.local/bin"
    )

    for file in "${!dotfiles[@]}"; do
        target="${dotfiles[$file]}"

        # Create the target directory if it doesn't exist
        mkdir -p "$target"

        # Create symlink
        ln -sfn "$(pwd)/$file" "$target/$file" && echo "Linked $file to $target/$file"
    done

    # Move fonts
    cp -r fonts/* ~/.local/share/fonts/
}

# Function to install necessary packages
install_packages() {
    echo "Installing necessary packages..."

    # Detect the OS
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
        ubuntu | debian)
            sudo apt update
            sudo apt install -y build-essential libc6-dev
            ;;
        arch)
            sudo pacman -Syu base-devel
            ;;
        *)
            echo "Unsupported OS: $ID"
            exit 1
            ;;
        esac
    else
        echo "Unable to detect the operating system."
        exit 1
    fi

    # Install Nix package manager
    sh <(curl -L https://nixos.org/nix/install) --no-daemon

    # Install packages using Nix
    nix-env -iA nixpkgs.git \
        nixpkgs.zsh \
        nixpkgs.neovim \
        nixpkgs.tmux \
        nixpkgs.fzf \
        nixpkgs.lazygit \
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
        nixpkgs.xsel

    # Install Oh My Zsh and plugins
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    git clone https://github.com/Aloxaf/fzf-tab "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/fzf-tab
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}"/plugins/zsh-completions
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

    # Change default shell to zsh
    chsh -s "$(which zsh)"

    # Install Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    # Install SDKMAN and NVM (Node Version Manager)
    curl -s "https://get.sdkman.io" | bash

    # Install fzf from GitHub
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install

    # Install Starship prompt and Zoxide
    curl -sS https://starship.rs/install.sh | sh
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
}

# Main function to execute the script steps
main() {
    link_dotfiles
    install_packages

    echo "Setup complete!"
}

main "$@"
