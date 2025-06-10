#!/bin/bash
# Update all tools and configurations
# ~/.dotfiles/scripts/update-all.sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Source Nix if available
source_nix() {
    if [[ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]]; then
        source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    elif [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
        source "$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi
}

# Update dotfiles repository
update_dotfiles() {
    log_info "Updating dotfiles repository..."

    local dotfiles_dir="${DOTFILES_DIR:-$HOME/.dotfiles}"

    if [[ -d "$dotfiles_dir/.git" ]]; then
        cd "$dotfiles_dir"

        # Check if there are uncommitted changes
        if ! git diff-index --quiet HEAD --; then
            log_warning "Uncommitted changes detected in dotfiles"
            log_info "Stashing changes before update..."
            git stash push -m "Auto-stash before update $(date)"
        fi

        # Update from remote
        local current_branch=$(git rev-parse --abbrev-ref HEAD)
        git fetch origin

        if git diff --quiet HEAD origin/"$current_branch"; then
            log_info "Dotfiles already up to date"
        else
            log_info "Updating dotfiles from origin/$current_branch"
            git pull origin "$current_branch"
            log_success "Dotfiles updated successfully"
        fi

        # Check if there are stashed changes
        if git stash list | grep -q "Auto-stash"; then
            log_info "Attempting to restore stashed changes..."
            if git stash pop; then
                log_success "Stashed changes restored"
            else
                log_warning "Conflicts detected. Please resolve manually with: git stash pop"
            fi
        fi
    else
        log_warning "Dotfiles directory is not a git repository"
    fi
}

# Update Nix packages
update_nix() {
    source_nix

    if ! command -v nix >/dev/null 2>&1; then
        log_warning "Nix not installed, skipping Nix updates"
        return 0
    fi

    log_info "Updating Nix channels..."
    nix-channel --update

    log_info "Updating Nix packages..."

    # Update all installed packages
    local outdated_packages
    outdated_packages=$(nix-env --query --available --status | grep "^I" | wc -l)

    if [[ "$outdated_packages" -gt 0 ]]; then
        log_info "Found $outdated_packages packages to update"
        nix-env --upgrade '*'
        log_success "Nix packages updated"
    else
        log_info "All Nix packages are up to date"
    fi

    # Garbage collection to free space
    log_info "Running garbage collection..."
    nix-collect-garbage -d >/dev/null 2>&1 || true
    log_success "Garbage collection complete"
}

# Update Oh My Zsh
update_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Updating Oh My Zsh..."

        # Update oh-my-zsh itself
        cd "$HOME/.oh-my-zsh"
        git pull origin master >/dev/null 2>&1 || {
            log_warning "Failed to update Oh My Zsh core"
        }

        log_success "Oh My Zsh updated"
    else
        log_warning "Oh My Zsh not installed"
    fi
}

# Update Zsh plugins
update_zsh_plugins() {
    local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

    if [[ ! -d "$plugins_dir" ]]; then
        log_warning "Zsh plugins directory not found"
        return 0
    fi

    log_info "Updating Zsh plugins..."

    local updated_count=0
    for plugin_dir in "$plugins_dir"/*; do
        if [[ -d "$plugin_dir/.git" ]]; then
            local plugin_name=$(basename "$plugin_dir")
            log_info "Updating plugin: $plugin_name"

            cd "$plugin_dir"
            local current_commit=$(git rev-parse HEAD)
            git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || {
                log_warning "Failed to update plugin: $plugin_name"
                continue
            }

            local new_commit=$(git rev-parse HEAD)
            if [[ "$current_commit" != "$new_commit" ]]; then
                ((updated_count++))
                log_success "Updated plugin: $plugin_name"
            fi
        fi
    done

    if [[ "$updated_count" -gt 0 ]]; then
        log_success "Updated $updated_count Zsh plugins"
    else
        log_info "All Zsh plugins are up to date"
    fi
}

# Update Tmux plugins
update_tmux_plugins() {
    if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
        log_info "Updating Tmux plugins..."

        # Update TPM itself
        cd "$HOME/.tmux/plugins/tpm"
        git pull origin master >/dev/null 2>&1 || {
            log_warning "Failed to update TPM"
        }

        # Update all tmux plugins
        if command -v tmux >/dev/null 2>&1; then
            # Check if tmux is running
            if tmux list-sessions >/dev/null 2>&1; then
                log_info "Updating tmux plugins via TPM..."
                "$HOME/.tmux/plugins/tpm/bin/update_plugins" all
            else
                log_info "Starting tmux to update plugins..."
                tmux new-session -d -s temp-update
                sleep 2
                "$HOME/.tmux/plugins/tpm/bin/update_plugins" all
                tmux kill-session -t temp-update 2>/dev/null || true
            fi
            log_success "Tmux plugins updated"
        else
            log_warning "Tmux not available"
        fi
    else
        log_warning "Tmux Plugin Manager not installed"
    fi
}

# Update language runtimes via mise
update_mise() {
    if command -v mise >/dev/null 2>&1; then
        log_info "Updating language runtimes with mise..."

        # Update mise itself
        mise self-update 2>/dev/null || log_warning "Failed to update mise"

        # Update all installed runtimes to latest versions
        mise upgrade 2>/dev/null || log_warning "Failed to upgrade runtimes"

        # Show current versions
        log_info "Current language runtime versions:"
        mise list 2>/dev/null || true

        log_success "Language runtimes updated"
    else
        log_warning "mise not installed"
    fi
}

# Update global npm packages
update_npm_globals() {
    if command -v npm >/dev/null 2>&1; then
        log_info "Updating global npm packages..."

        # Get list of outdated global packages
        local outdated
        outdated=$(npm outdated -g --parseable --depth=0 2>/dev/null | cut -d: -f4 | sort -u)

        if [[ -n "$outdated" ]]; then
            log_info "Updating npm packages: $outdated"
            npm update -g $outdated
            log_success "Global npm packages updated"
        else
            log_info "All global npm packages are up to date"
        fi
    else
        log_warning "npm not available"
    fi
}

# Update Python global packages
update_python_globals() {
    if command -v pip >/dev/null 2>&1; then
        log_info "Updating global Python packages..."

        # Update pip itself
        pip install --upgrade pip >/dev/null 2>&1 || log_warning "Failed to update pip"

        # Update common global packages
        local python_packages=("poetry" "black" "flake8" "mypy" "pytest" "pipx")
        for package in "${python_packages[@]}"; do
            if pip show "$package" >/dev/null 2>&1; then
                pip install --upgrade "$package" >/dev/null 2>&1 || log_warning "Failed to update $package"
            fi
        done

        log_success "Python packages updated"
    else
        log_warning "pip not available"
    fi
}

# Update Rust toolchain and crates
update_rust() {
    if command -v rustup >/dev/null 2>&1; then
        log_info "Updating Rust toolchain..."

        rustup update stable >/dev/null 2>&1 || log_warning "Failed to update Rust"

        # Update cargo packages if cargo-update is installed
        if command -v cargo-install-update >/dev/null 2>&1; then
            log_info "Updating Rust packages..."
            cargo install-update -a >/dev/null 2>&1 || log_warning "Failed to update Rust packages"
        fi

        log_success "Rust toolchain updated"
    else
        log_warning "Rust not installed via rustup"
    fi
}

# Update system packages (optional)
update_system() {
    if [[ "${UPDATE_SYSTEM:-false}" == "true" ]]; then
        log_info "Updating system packages..."

        if command -v apt >/dev/null 2>&1; then
            sudo apt update && sudo apt upgrade -y
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -Syu --noconfirm
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf upgrade -y
        elif command -v brew >/dev/null 2>&1; then
            brew update && brew upgrade
        else
            log_warning "Unknown package manager, skipping system update"
            return 0
        fi

        log_success "System packages updated"
    else
        log_info "Skipping system package update (set UPDATE_SYSTEM=true to enable)"
    fi
}

# Show update summary
show_summary() {
    log_success "Update process completed!"
    echo ""
    log_info "What was updated:"
    echo "  ✓ Dotfiles repository"
    echo "  ✓ Nix packages and channels"
    echo "  ✓ Oh My Zsh and plugins"
    echo "  ✓ Tmux plugins"
    echo "  ✓ Language runtimes (mise)"
    echo "  ✓ Global packages (npm, pip, cargo)"
    echo ""
    log_info "You may want to:"
    echo "  • Restart your terminal for all changes to take effect"
    echo "  • Check for any conflicts in dotfiles (if auto-stashed)"
    echo "  • Review new features in updated tools"
    echo ""
    log_info "Next scheduled update: $(date -d '+1 week' 2>/dev/null || date -v +1w 2>/dev/null || echo 'in one week')"
}

# Main update function
main() {
    local start_time=$(date +%s)

    log_info "Starting comprehensive update process..."
    log_info "Started at: $(date)"
    echo ""

    # Parse options
    while [[ $# -gt 0 ]]; do
        case $1 in
        --system)
            export UPDATE_SYSTEM=true
            shift
            ;;
        --dry-run)
            log_info "DRY RUN mode - would perform updates"
            exit 0
            ;;
        -h | --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --system    Also update system packages"
            echo "  --dry-run   Show what would be updated"
            echo "  -h, --help  Show this help"
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            exit 1
            ;;
        esac
    done

    # Run updates
    update_dotfiles
    update_nix
    update_oh_my_zsh
    update_zsh_plugins
    update_tmux_plugins
    update_mise
    update_npm_globals
    update_python_globals
    update_rust
    update_system

    # Calculate elapsed time
    local end_time=$(date +%s)
    local elapsed=$((end_time - start_time))
    local elapsed_min=$((elapsed / 60))
    local elapsed_sec=$((elapsed % 60))

    echo ""
    show_summary
    log_info "Total time: ${elapsed_min}m ${elapsed_sec}s"
}

# Run main function with all arguments
main "$@"
