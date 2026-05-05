#!/bin/bash

# Hyprland Installation Script - Best of Both Worlds Approach
# Combines HyDE's sophisticated installation with full user config control

set -e

# Colors and logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
section() { echo -e "\n${CYAN}=== $1 ===${NC}"; }

# Script directory and logging setup
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
LOG_DIR="$HOME/.cache/hyprland-install/$(date +'%y%m%d_%Hh%Mm%Ss')"
mkdir -p "$LOG_DIR"

# Configuration flags
FLG_INSTALL=0
FLG_SERVICES=0
FLG_NVIDIA=1
FLG_DRYRUN=0
USE_DEFAULT=""
AUR_HELPER=""
SHELL_CHOICE=""

# Package arrays
declare -a CORE_PACKAGES
declare -a EXTRA_PACKAGES
declare -a AUR_PACKAGES
declare -a NVIDIA_PACKAGES

#------------------#
# Utility Functions #
#------------------#

# Check if running as root
check_root() {
  if [[ $EUID -eq 0 ]]; then
    error "This script should not be run as root"
    exit 1
  fi
}

# Check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Prompt with timeout
prompt_timer() {
  local timeout=$1
  local prompt_msg=$2
  local response=""

  echo -n "$prompt_msg"
  if command_exists timeout; then
    if ! response=$(timeout "$timeout" bash -c 'read -r input; echo "$input"' 2>/dev/null); then
      echo "" # New line after timeout
      return 1
    fi
  else
    read -r response
  fi

  PROMPT_INPUT="$response"
  return 0
}

#------------------#
# Package Definitions #
#------------------#

setup_package_lists() {
  # Core system packages (always installed)
  CORE_PACKAGES=(
    # Audio System
    "pipewire"
    "pipewire-alsa"
    "pipewire-audio"
    "pipewire-jack"
    "pipewire-pulse"
    "gst-plugin-pipewire"
    "wireplumber"
    "pavucontrol"
    "pamixer"

    # Network & Bluetooth
    "networkmanager"
    "network-manager-applet"
    "bluez"
    "bluez-utils"
    "blueman"

    # System Control
    "brightnessctl"
    "playerctl"
    "udiskie"

    # Hyprland Core
    "hyprland"
    "dunst"
    "waybar"
    "grim"
    "slurp"
    "wl-clipboard"
    "cliphist"
    "wl-clip-persist"
    "hyprlock"
    "hypridle"
    "hyprsunset"

    # Dependencies
    "polkit-gnome"
    "xdg-desktop-portal-hyprland"
    "xdg-desktop-portal-gtk"
    "xdg-user-dirs"
    "pacman-contrib"
    "parallel"
    "jq"
    "imagemagick"
    "qt5-imageformats"
    "ffmpegthumbs"
    "kde-cli-tools"
    "libnotify"
    "noto-fonts-emoji"

    # Wayland Support
    "qt5-wayland"
    "qt6-wayland"

    # File Management
    "dolphin"
    "ark"
    "unzip"

    # Basic Applications
    "firefox"
    "kitty"
    "vim"

    # System Info
    "fastfetch"
  )

  # Extra packages (optional but recommended)
  EXTRA_PACKAGES=(
    # Launchers & Bars
    "rofi-wayland"
    "swww"
    "wlogout"

    # Theming
    "nwg-look"
    "qt5ct"
    "qt6ct"
    "kvantum"
    "kvantum-qt5"

    # Utilities
    "hyprpicker"
    "satty"
    "nwg-displays"
    "fzf"

    # Applications
    "code"
    "gimp"
    "vlc"
    "libreoffice-fresh"

    # Development
    "git"
    "base-devel"
    "python"
    "nodejs"
    "npm"

    # Gaming (optional)
    "steam"
    "gamemode"
    "mangohud"

    # Media
    "cava"

    # Fonts
    "ttf-liberation"
    "ttf-dejavu"
    "ttf-hack"
    "ttf-fira-code"
    "noto-fonts"
  )

  # AUR packages
  AUR_PACKAGES=(
    "hyprpicker"
    "swayosd-git"
    "wttrbar"
    "spotify"
    "spicetify-cli"
    "wf-recorder"
    "visual-studio-code-bin"
  )
}

# Shell-specific package selection
setup_shell_packages() {
  case "$SHELL_CHOICE" in
  "zsh")
    EXTRA_PACKAGES+=("zsh" "eza" "starship" "duf")
    AUR_PACKAGES+=("zsh-theme-powerlevel10k-git")
    ;;
  "fish")
    EXTRA_PACKAGES+=("fish" "eza" "starship" "duf")
    ;;
  *)
    warn "Unknown shell choice: $SHELL_CHOICE"
    ;;
  esac
}

#------------------#
# Installation Functions #
#------------------#

# Install AUR helper
install_aur_helper() {
  if command_exists yay && command_exists paru; then
    log "Both yay and paru are available"
    return 0
  fi

  if [[ -z "$AUR_HELPER" ]]; then
    section "AUR Helper Selection"
    echo "1) yay"
    echo "2) paru"
    echo "3) yay-bin (binary)"
    echo "4) paru-bin (binary)"

    if ! prompt_timer 30 "Select AUR helper [1-4, default: 3]: "; then
      log "Timeout - defaulting to yay-bin"
      AUR_HELPER="yay-bin"
    else
      case "$PROMPT_INPUT" in
      1) AUR_HELPER="yay" ;;
      2) AUR_HELPER="paru" ;;
      3) AUR_HELPER="yay-bin" ;;
      4) AUR_HELPER="paru-bin" ;;
      *) AUR_HELPER="yay-bin" ;;
      esac
    fi
  fi

  log "Installing AUR helper: $AUR_HELPER"

  if [[ "$AUR_HELPER" == *"-bin" ]]; then
    # Install binary version from AUR
    cd /tmp
    git clone "https://aur.archlinux.org/${AUR_HELPER}.git"
    cd "$AUR_HELPER"
    makepkg -si --noconfirm
    cd ~
  else
    # Install from source
    cd /tmp
    git clone "https://aur.archlinux.org/${AUR_HELPER}.git"
    cd "$AUR_HELPER"
    makepkg -si --noconfirm
    cd ~
  fi
}

# Get shell choice
get_shell_choice() {
  if [[ -z "$SHELL_CHOICE" ]]; then
    section "Shell Selection"
    echo "1) zsh (recommended)"
    echo "2) fish"

    if ! prompt_timer 30 "Select shell [1-2, default: 1]: "; then
      log "Timeout - defaulting to zsh"
      SHELL_CHOICE="zsh"
    else
      case "$PROMPT_INPUT" in
      1) SHELL_CHOICE="zsh" ;;
      2) SHELL_CHOICE="fish" ;;
      *) SHELL_CHOICE="zsh" ;;
      esac
    fi
  fi

  log "Selected shell: $SHELL_CHOICE"
}

# Install packages with error handling
install_packages() {
  local pkg_manager="$1"
  shift
  local packages=("$@")
  local failed_packages=()

  log "Installing packages with $pkg_manager: ${packages[*]}"

  for package in "${packages[@]}"; do
    log "Installing: $package"
    if [[ "$FLG_DRYRUN" -eq 1 ]]; then
      log "[DRY RUN] Would install: $package"
      continue
    fi

    case "$pkg_manager" in
    "pacman")
      if ! sudo pacman -S --noconfirm "$package" 2>>"$LOG_DIR/install.log"; then
        failed_packages+=("$package")
        warn "Failed to install: $package"
      fi
      ;;
    "yay" | "paru")
      if ! "$pkg_manager" -S --noconfirm "$package" 2>>"$LOG_DIR/install.log"; then
        failed_packages+=("$package")
        warn "Failed to install: $package"
      fi
      ;;
    esac
  done

  if [[ ${#failed_packages[@]} -gt 0 ]]; then
    warn "Failed packages: ${failed_packages[*]}"
    echo "${failed_packages[*]}" >>"$LOG_DIR/failed_packages.txt"
  fi
}

# Enable services
enable_services() {
  section "Enabling System Services"

  local services=(
    "NetworkManager"
    "bluetooth"
  )

  for service in "${services[@]}"; do
    log "Enabling service: $service"
    if [[ "$FLG_DRYRUN" -eq 1 ]]; then
      log "[DRY RUN] Would enable: $service"
    else
      sudo systemctl enable "$service"
    fi
  done

  # Add user to groups
  log "Adding user to relevant groups"
  if [[ "$FLG_DRYRUN" -eq 1 ]]; then
    log "[DRY RUN] Would add user to: audio,video,input,render groups"
  else
    sudo usermod -aG audio,video,input,render "$(whoami)"
  fi
}

#------------------#
# Main Functions #
#------------------#

# Parse command line arguments
parse_args() {
  while getopts "isndh:a:t" opt; do
    case $opt in
    i) FLG_INSTALL=1 ;;
    s) FLG_SERVICES=1 ;;
    n) FLG_NVIDIA=0 ;;
    d)
      FLG_INSTALL=1
      USE_DEFAULT="--noconfirm"
      ;;
    h) SHELL_CHOICE="$OPTARG" ;;
    a) AUR_HELPER="$OPTARG" ;;
    t) FLG_DRYRUN=1 ;;
    *)
      cat <<EOF
Usage: $0 [options]
    -i          Install packages
    -s          Enable system services  
    -n          Skip NVIDIA detection/installation
    -d          Install with defaults (no prompts)
    -h SHELL    Pre-select shell (zsh/fish)
    -a HELPER   Pre-select AUR helper (yay/paru/yay-bin/paru-bin)
    -t          Test run (dry run mode)

Examples:
    $0 -i -s           # Install packages and enable services
    $0 -i -n           # Install without NVIDIA packages
    $0 -d              # Install with defaults, no prompts
    $0 -t -i -s        # Test run
EOF
      exit 1
      ;;
    esac
  done

  # Default behavior if no args
  if [[ $OPTIND -eq 1 ]]; then
    FLG_INSTALL=1
    FLG_SERVICES=1
  fi
}

# Main installation routine
main_install() {
  section "Hyprland Installation"

  # Update system
  log "Updating system packages..."
  if [[ "$FLG_DRYRUN" -eq 1 ]]; then
    log "[DRY RUN] Would update system"
  else
    sudo pacman -Syu $USE_DEFAULT
  fi

  # Setup package lists
  setup_package_lists

  # Get user preferences
  if [[ -z "$USE_DEFAULT" ]]; then
    install_aur_helper
    get_shell_choice
  else
    AUR_HELPER="yay-bin"
    SHELL_CHOICE="zsh"
    log "Using defaults: $AUR_HELPER, $SHELL_CHOICE"
  fi

  # Add shell-specific packages
  setup_shell_packages

  # Add NVIDIA packages if detected and not disabled
  if [[ "$FLG_NVIDIA" -eq 1 ]] && nvidia_detect; then
    log "Adding NVIDIA packages"
    while IFS= read -r pkg; do
      NVIDIA_PACKAGES+=("$pkg")
    done < <(get_nvidia_packages)
    CORE_PACKAGES+=("${NVIDIA_PACKAGES[@]}")
  fi

  # Install AUR helper if needed
  if [[ -z "$USE_DEFAULT" ]] && ! command_exists yay && ! command_exists paru; then
    install_aur_helper
  fi

  # Determine which AUR helper to use
  local aur_cmd=""
  if command_exists yay; then
    aur_cmd="yay"
  elif command_exists paru; then
    aur_cmd="paru"
  else
    error "No AUR helper found after installation"
    exit 1
  fi

  # Install packages
  install_packages "pacman" "${CORE_PACKAGES[@]}"
  install_packages "pacman" "${EXTRA_PACKAGES[@]}"
  install_packages "$aur_cmd" "${AUR_PACKAGES[@]}"

  log "Package installation completed"
  log "Check $LOG_DIR for detailed logs"
}

#------------------#
# Entry Point #
#------------------#

main() {
  cat <<"EOF"
╔═══════════════════════════════════════════════════════════════╗
║                    Hyprland Installation                     ║
║              Best of Both Worlds Approach                    ║
║          Full Control + Sophisticated Installation           ║
╚═══════════════════════════════════════════════════════════════╝
EOF

  check_root
  parse_args "$@"

  if [[ "$FLG_DRYRUN" -eq 1 ]]; then
    warn "DRY RUN MODE - No changes will be made"
  fi

  if [[ "$FLG_INSTALL" -eq 1 ]]; then
    main_install
  fi

  if [[ "$FLG_SERVICES" -eq 1 ]]; then
    enable_services
  fi

  section "Installation Summary"
  log "✅ Installation completed successfully!"
  log "📁 Logs saved to: $LOG_DIR"
  log "🔧 Config files are yours to control - no abstraction layer"
  log ""
  log "Next steps:"
  log "1. Reboot your system"
  log "2. Select Hyprland from your display manager"
  log "3. Create your own configs in ~/.config/hypr/"
  log "4. Customize waybar, dunst, etc. to your liking"

  if [[ "$FLG_DRYRUN" -ne 1 ]]; then
    echo ""
    read -p "Reboot system now? (y/N): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      sudo reboot
    fi
  fi
}

# Run main function
main "$@"
