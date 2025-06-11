#!/bin/bash
# Nix package manager installation script
# ~/.dotfiles/scripts/install-nix.sh

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

# Detect operating system
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [[ -f /etc/os-release ]]; then
            . /etc/os-release
            echo "$ID"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Check if running in WSL
is_wsl() {
    [[ -n "${WSL_DISTRO_NAME:-}" ]] || [[ -n "${WSL_INTEROP:-}" ]] || [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]
}

# Install Nix package manager
install_nix() {
    if command -v nix >/dev/null 2>&1; then
        log_info "Nix is already installed at: $(which nix)"
        nix --version
        return 0
    fi

    local os=$(detect_os)
    log_info "Installing Nix package manager on $os..."

    # Download and verify the installer
    local installer_url="https://nixos.org/nix/install"
    local installer_file="/tmp/nix-installer.sh"

    log_info "Downloading Nix installer..."
    curl -fsSL "$installer_url" -o "$installer_file"

    # Make installer executable
    chmod +x "$installer_file"

    # Install based on OS
    case "$os" in
    "macos")
        log_info "Installing Nix for macOS..."
        # Use multi-user installation on macOS (recommended)
        sh "$installer_file" --daemon
        ;;
    "ubuntu" | "debian" | "arch" | "fedora" | "centos" | "rhel" | *"linux"*)
        if is_wsl || [[ -n "${container:-}" ]] || [[ -f /.dockerenv ]]; then
            log_info "Installing Nix for WSL (single-user)..."
            sh "$installer_file" --no-daemon
        else
            log_info "Installing Nix for Linux..."
            # Try multi-user first, fallback to single-user
            if sh "$installer_file" --daemon 2>/dev/null; then
                log_success "Multi-user installation successful"
            else
                log_warning "Multi-user installation failed, trying single-user..."
                sh "$installer_file" --no-daemon
            fi
        fi
        ;;
    *)
        log_warning "Unknown OS, attempting single-user installation..."
        sh "$installer_file" --no-daemon
        ;;
    esac

    # Clean up installer
    rm -f "$installer_file"

    log_success "Nix installation complete!"
}

# Source Nix in current session
source_nix() {
    log_info "Sourcing Nix environment..."

    # Try different possible locations
    local nix_profile_script=""

    if [[ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]]; then
        # Multi-user installation
        nix_profile_script="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    elif [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
        # Single-user installation
        nix_profile_script="$HOME/.nix-profile/etc/profile.d/nix.sh"
    elif [[ -f "/etc/profile.d/nix.sh" ]]; then
        # System-wide installation
        nix_profile_script="/etc/profile.d/nix.sh"
    fi

    if [[ -n "$nix_profile_script" ]]; then
        log_info "Sourcing Nix from: $nix_profile_script"
        source "$nix_profile_script"
    else
        log_warning "Could not find Nix profile script"
        return 1
    fi

    # Verify Nix is available
    if command -v nix >/dev/null 2>&1; then
        log_success "Nix is now available in current session"
        nix --version
    else
        log_error "Nix installation may have failed"
        return 1
    fi
}

# Configure Nix settings
configure_nix() {
    log_info "Configuring Nix settings..."

    # Create Nix config directory
    local nix_config_dir="$HOME/.config/nix"
    mkdir -p "$nix_config_dir"

    # Configure Nix with modern features and optimizations
    cat >"$nix_config_dir/nix.conf" <<'EOF'
# Enable experimental features
experimental-features = nix-command flakes

# Optimize storage
auto-optimise-store = true
warn-dirty = false

# Substituters for faster downloads
substituters = https://cache.nixos.org/ https://nix-community.cachix.org
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=

# Build settings
max-jobs = auto
cores = 0

# Keep build logs
keep-outputs = true
keep-derivations = true

# Show more information
show-trace = true
EOF

    log_success "Nix configuration written to $nix_config_dir/nix.conf"
}

# Add Nix to shell profiles
setup_shell_integration() {
    log_info "Setting up shell integration..."

    local nix_source_line=""

    # Determine the correct source line
    if [[ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]]; then
        nix_source_line='if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh; fi'
    elif [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
        nix_source_line='if [ -e '"$HOME"'/.nix-profile/etc/profile.d/nix.sh ]; then . '"$HOME"'/.nix-profile/etc/profile.d/nix.sh; fi'
    fi

    if [[ -z "$nix_source_line" ]]; then
        log_warning "Could not determine Nix source line"
        return 1
    fi

    # Add to shell profiles if not already present
    local shell_files=("$HOME/.profile" "$HOME/.bashrc" "$HOME/.zshrc")

    for shell_file in "${shell_files[@]}"; do
        if [[ -f "$shell_file" ]] && ! grep -q "nix-daemon.sh\|nix\.sh" "$shell_file"; then
            log_info "Adding Nix to $shell_file"
            echo "" >>"$shell_file"
            echo "# Nix package manager" >>"$shell_file"
            echo "$nix_source_line" >>"$shell_file"
        fi
    done

    # Special handling for zsh in our dotfiles setup
    local zshenv_file="$HOME/.zshenv"
    if [[ -f "$zshenv_file" ]] && ! grep -q "nix-daemon.sh\|nix\.sh" "$zshenv_file"; then
        log_info "Adding Nix to $zshenv_file"
        echo "" >>"$zshenv_file"
        echo "# Source Nix environment if it exists" >>"$zshenv_file"
        echo "$nix_source_line" >>"$zshenv_file"
    fi

    log_success "Shell integration configured"
}

# Install essential packages to test Nix
install_test_packages() {
    log_info "Installing essential test packages..."

    # Test basic package installation
    local test_packages=("hello" "cowsay")

    for package in "${test_packages[@]}"; do
        if nix-env -iA "nixpkgs.$package" >/dev/null 2>&1; then
            log_success "Successfully installed $package"
        else
            log_warning "Failed to install $package"
        fi
    done

    # Test installed package
    if command -v hello >/dev/null 2>&1; then
        log_info "Testing installation:"
        hello
    fi

    # Clean up test packages
    log_info "Cleaning up test packages..."
    nix-env -e hello cowsay >/dev/null 2>&1 || true
}

# Update Nix channel
update_nix_channel() {
    log_info "Updating Nix channels..."

    # Add nixpkgs channel if not present
    if ! nix-channel --list | grep -q nixpkgs; then
        log_info "Adding nixpkgs channel..."
        nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
    fi

    # Update channels
    nix-channel --update

    log_success "Nix channels updated"
}

# Show post-installation information
show_post_install_info() {
    log_success "Nix installation complete!"
    echo ""
    log_info "Next steps:"
    echo "  1. Restart your terminal or run:"
    echo "     source ~/.nix-profile/etc/profile.d/nix.sh"
    echo "  2. Install your dotfiles:"
    echo "     cd ~/.dotfiles && ./install.sh"
    echo ""
    log_info "Useful Nix commands:"
    echo "  nix-env -iA nixpkgs.PACKAGE    # Install a package"
    echo "  nix-env -q                     # List installed packages"
    echo "  nix-env -e PACKAGE             # Uninstall a package"
    echo "  nix-env --list-generations     # Show package generations"
    echo "  nix-env --rollback             # Rollback to previous generation"
    echo "  nix-channel --update           # Update package channels"
    echo "  nix-collect-garbage            # Clean up old packages"
    echo ""
    log_info "Documentation:"
    echo "  https://nixos.org/guides/how-nix-works.html"
    echo "  https://nixos.org/manual/nix/stable/"
}

# Uninstall Nix (for testing/cleanup)
uninstall_nix() {
    log_warning "This will completely remove Nix from your system!"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Uninstall cancelled"
        return 0
    fi

    log_info "Uninstalling Nix..."

    # Stop and remove daemon (multi-user installation)
    if [[ -f "/etc/systemd/system/nix-daemon.service" ]]; then
        sudo systemctl stop nix-daemon
        sudo systemctl disable nix-daemon
        sudo rm -f /etc/systemd/system/nix-daemon.service
    fi

    # Remove Nix directories
    sudo rm -rf /nix
    sudo rm -rf /etc/nix

    # Remove user profile
    rm -rf "$HOME/.nix-profile"
    rm -rf "$HOME/.nix-defexpr"
    rm -rf "$HOME/.nix-channels"
    rm -rf "$HOME/.config/nix"

    # Remove from shell profiles
    local shell_files=("$HOME/.profile" "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.zshenv")
    for shell_file in "${shell_files[@]}"; do
        if [[ -f "$shell_file" ]]; then
            sed -i.bak '/nix-daemon.sh\|nix\.sh/d' "$shell_file" 2>/dev/null || true
            sed -i.bak '/# Nix package manager/d' "$shell_file" 2>/dev/null || true
        fi
    done

    log_success "Nix uninstalled successfully"
    log_info "You may need to restart your terminal"
}

# Main function
main() {
    case "${1:-install}" in
    "install")
        log_info "Starting Nix installation..."
        install_nix
        source_nix
        configure_nix
        setup_shell_integration
        update_nix_channel
        install_test_packages
        show_post_install_info
        ;;
    "uninstall")
        uninstall_nix
        ;;
    "configure")
        configure_nix
        setup_shell_integration
        ;;
    "test")
        source_nix
        install_test_packages
        ;;
    *)
        echo "Usage: $0 [install|uninstall|configure|test]"
        echo ""
        echo "Commands:"
        echo "  install     Install Nix package manager (default)"
        echo "  uninstall   Remove Nix completely"
        echo "  configure   Configure Nix settings"
        echo "  test        Test Nix installation"
        exit 1
        ;;
    esac
}

# Run main function with all arguments
main "$@"
