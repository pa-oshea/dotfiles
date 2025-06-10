#!/bin/bash
# Main dotfiles installation script
# ~/.dotfiles/install.sh

set -e

# Configuration
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Help function
show_help() {
    cat <<EOF
Usage: $0 [OPTIONS]

OPTIONS:
    -h, --help      Show this help
    -f, --force     Force installation (overwrite existing)
    -b, --backup    Create backup before installation
    --dry-run       Show what would be installed
    --languages     Install language-specific tools

EXAMPLES:
    $0                      # Install all tools
    $0 --backup             # Install with backup
    $0 --languages rust go  # Install with specific languages
EOF
}

# Parse arguments
FORCE=false
BACKUP=false
DRY_RUN=false
LANGUAGES=()

while [[ $# -gt 0 ]]; do
    case $1 in
    -h | --help)
        show_help
        exit 0
        ;;
    -f | --force)
        FORCE=true
        shift
        ;;
    -b | --backup)
        BACKUP=true
        shift
        ;;
    --dry-run)
        DRY_RUN=true
        shift
        ;;
    --languages)
        shift
        while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
            LANGUAGES+=("$1")
            shift
        done
        ;;
    *)
        log_error "Unknown option: $1"
        show_help
        exit 1
        ;;
    esac
done

# Check if Nix is installed
check_nix() {
    if ! command -v nix >/dev/null 2>&1; then
        log_error "Nix is not installed. Please run: ./scripts/install-nix.sh"
        exit 1
    fi

    # Source Nix in current session
    if [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
        source ~/.nix-profile/etc/profile.d/nix.sh
    elif [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi
}

# Install packages
install_packages() {
    log_info "Installing essential CLI utilities and development tools..."

    if [[ "$DRY_RUN" == true ]]; then
        log_info "DRY RUN - Would install:"
        echo "  - Essential CLI utilities and development tools"
        [[ ${#LANGUAGES[@]} -gt 0 ]] && echo "  - Language tools: ${LANGUAGES[*]}"
        return 0
    fi

    log_info "Installing core packages..."
    nix-env -if "$DOTFILES_DIR/nix/packages/core.nix"

    # Install language-specific packages
    for lang in "${LANGUAGES[@]}"; do
        local lang_file="$DOTFILES_DIR/nix/packages/languages/${lang}.nix"
        if [[ -f "$lang_file" ]]; then
            log_info "Installing $lang tools..."
            nix-env -if "$lang_file"
        else
            log_warning "Language file not found: $lang_file"
        fi
    done

    log_success "Package installation complete!"
}

# Install shell enhancements (not available in Nix)
install_shell_enhancements() {
    if [[ "$DRY_RUN" == true ]]; then
        log_info "DRY RUN - Would install shell enhancements"
        return 0
    fi

    log_info "Installing shell enhancements..."

    # Oh My Zsh
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        log_info "Oh My Zsh already installed"
    fi

    # Zsh plugins
    local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    mkdir -p "$plugins_dir"

    install_zsh_plugin() {
        local repo="$1"
        local name="$2"
        if [[ ! -d "$plugins_dir/$name" ]]; then
            log_info "Installing zsh plugin: $name"
            git clone --depth=1 "https://github.com/$repo" "$plugins_dir/$name"
        else
            log_info "Plugin $name already installed"
        fi
    }

    install_zsh_plugin "zsh-users/zsh-autosuggestions" "zsh-autosuggestions"
    install_zsh_plugin "zsh-users/zsh-syntax-highlighting" "zsh-syntax-highlighting"
    install_zsh_plugin "zsh-users/zsh-completions" "zsh-completions"
    install_zsh_plugin "Aloxaf/fzf-tab" "fzf-tab"

    # Tmux plugin manager
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        log_info "Installing Tmux Plugin Manager..."
        git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
        log_info "TPM already installed"
    fi

    log_success "Shell enhancements installed!"
}

# Setup symbolic links
setup_symlinks() {
    if [[ "$DRY_RUN" == true ]]; then
        log_info "DRY RUN - Would create symbolic links"
        return 0
    fi

    log_info "Setting up symbolic links..."

    # Create necessary directories
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.local/bin"

    # Core config links
    create_symlink "$DOTFILES_DIR/zsh" "$HOME/.config/zsh"
    create_symlink "$DOTFILES_DIR/tmux" "$HOME/.config/tmux"
    create_symlink "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
    create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

    # Scripts
    if [[ -f "$DOTFILES_DIR/scripts/tmux-sessionizer.sh" ]]; then
        create_symlink "$DOTFILES_DIR/scripts/tmux-sessionizer.sh" "$HOME/.local/bin/tmux-sessionizer.sh"
        chmod +x "$HOME/.local/bin/tmux-sessionizer.sh"
    fi

    log_success "Symbolic links created!"
}

create_symlink() {
    local source="$1"
    local dest="$2"

    if [[ ! -e "$source" ]]; then
        log_warning "Source does not exist: $source"
        return 1
    fi

    # Create parent directory
    mkdir -p "$(dirname "$dest")"

    if [[ -L "$dest" ]]; then
        if [[ "$(readlink "$dest")" == "$source" ]]; then
            log_info "Symlink already correct: $dest"
            return 0
        else
            log_info "Updating symlink: $dest"
            rm "$dest"
        fi
    elif [[ -e "$dest" ]]; then
        if [[ "$FORCE" == true ]]; then
            log_warning "Removing existing file: $dest"
            rm -rf "$dest"
        else
            log_error "File exists (use --force to overwrite): $dest"
            return 1
        fi
    fi

    ln -s "$source" "$dest"
    log_success "Created symlink: $dest -> $source"
}

# Setup mise for language runtime management
setup_mise() {
    if [[ "$DRY_RUN" == true ]]; then
        log_info "DRY RUN - Would setup mise"
        return 0
    fi

    if command -v mise >/dev/null 2>&1; then
        log_info "Setting up language runtimes with mise..."

        # Install default versions if specified
        if [[ " ${LANGUAGES[*]} " =~ " node " ]]; then
            mise install node@lts 2>/dev/null || log_warning "Failed to install Node.js"
        fi
        if [[ " ${LANGUAGES[*]} " =~ " python " ]]; then
            mise install python@latest 2>/dev/null || log_warning "Failed to install Python"
        fi
        if [[ " ${LANGUAGES[*]} " =~ " go " ]]; then
            mise install go@latest 2>/dev/null || log_warning "Failed to install Go"
        fi
        if [[ " ${LANGUAGES[*]} " =~ " rust " ]]; then
            mise install rust@stable 2>/dev/null || log_warning "Failed to install Rust"
        fi

        log_success "Language runtimes configured!"
    else
        log_warning "mise not available, skipping language runtime setup"
    fi
}

# Create backup
create_backup() {
    if [[ "$DRY_RUN" == true ]]; then
        log_info "DRY RUN - Would create backup"
        return 0
    fi

    log_info "Creating backup in $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"

    # Backup existing dotfiles
    for file in .zshrc .zshenv .gitconfig .tmux.conf; do
        if [[ -f "$HOME/$file" ]]; then
            cp "$HOME/$file" "$BACKUP_DIR/"
        fi
    done

    # Backup config directories
    for dir in zsh tmux; do
        if [[ -d "$HOME/.config/$dir" ]]; then
            cp -r "$HOME/.config/$dir" "$BACKUP_DIR/"
        fi
    done

    log_success "Backup created in $BACKUP_DIR"
}

# Post-installation configuration
post_install() {
    if [[ "$DRY_RUN" == true ]]; then
        log_info "DRY RUN - Would run post-installation steps"
        return 0
    fi

    log_info "Running post-installation configuration..."

    # Change default shell to zsh
    if [[ "$SHELL" != *"zsh" ]]; then
        log_info "Changing default shell to zsh..."
        chsh -s "$(which zsh)" || log_warning "Failed to change shell, please run: chsh -s \$(which zsh)"
    fi

    log_success "Post-installation complete!"
}

# Main installation function
main() {
    log_info "Starting dotfiles installation..."
    log_info "Directory: $DOTFILES_DIR"
    [[ ${#LANGUAGES[@]} -gt 0 ]] && log_info "Languages: ${LANGUAGES[*]}"

    # Verify we're in the right directory
    if [[ ! -d "$DOTFILES_DIR/nix/packages" ]]; then
        log_error "Nix packages directory not found. Are you in the right directory?"
        exit 1
    fi

    # Pre-flight checks
    check_nix

    # Create backup if requested
    if [[ "$BACKUP" == true ]]; then
        create_backup
    fi

    # Install packages
    install_packages

    # Install shell enhancements
    install_shell_enhancements

    # Setup configuration
    setup_symlinks

    # Setup language runtimes
    if [[ ${#LANGUAGES[@]} -gt 0 ]]; then
        setup_mise
    fi

    # Post-installation
    post_install

    log_success "Installation complete!"
    log_info ""
    log_info "Next steps:"
    log_info "  1. Restart your terminal or run: source ~/.zshrc"
    log_info "  2. Install tmux plugins: prefix + I (in tmux)"
    if [[ ${#LANGUAGES[@]} -gt 0 ]]; then
        log_info "  3. Check language versions: mise list"
    fi
    log_info ""
    log_info "Useful commands:"
    log_info "  ./scripts/update-all.sh      # Update everything"
    log_info "  nix-env --list-generations   # Show package generations"
    log_info "  nix-env --rollback           # Rollback if issues"
}

# Run main function
main "$@"
