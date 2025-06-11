#!/bin/bash
# Quick setup script for new machines
# ~/.dotfiles/scripts/quick-setup.sh

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Detect if this is first run
is_first_run() {
    [[ ! -d "$HOME/.oh-my-zsh" ]] || [[ ! -f "$HOME/.zshrc" ]]
}

main() {
    log_info "🚀 Quick dotfiles setup for new machine"

    # Check if we're in dotfiles directory
    if [[ ! -f "install.sh" ]]; then
        log_warning "Please run this from your dotfiles directory"
        exit 1
    fi

    # Install Nix if not present
    if ! command -v nix >/dev/null 2>&1; then
        log_info "📦 Installing Nix package manager..."
        ./scripts/install-nix.sh

        # Source Nix for current session
        if [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
            source ~/.nix-profile/etc/profile.d/nix.sh
        fi
    fi

    # Run main installation
    log_info "⚙️  Installing dotfiles..."
    if is_first_run; then
        ./install.sh --backup
    else
        ./install.sh
    fi

    log_success "✅ Setup complete!"
    log_info ""
    log_info "🎯 What's installed:"
    log_info "   • Essential CLI tools (zsh, fzf, ripgrep, bat, etc.)"
    log_info "   • Development tools (git, tmux, neovim, docker, etc.)"
    log_info ""
    log_info "🔧 Next steps:"
    log_info "   1. Restart your terminal"
    log_info "   2. Install tmux plugins: Ctrl+Space + I"
    log_info "   3. Set up language versions: mise list"
    log_info ""
    log_info "📚 Useful commands:"
    log_info "   mise install node@20        # Install specific Node version"
    log_info "   sdk install java 21.0.1-tem # Install Java via SDKMAN"
    log_info "   ./scripts/update-all.sh     # Update everything"
}

main "$@"
