# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Use Arch Linux box that supports libvirt
  config.vm.box = "generic/arch"
  config.vm.box_check_update = true
  
  # Set VM hostname
  config.vm.hostname = "arch-vagrant-i3"
  
  # Optional: Share your dotfiles directory for easy testing
  # Uncomment the line below to mount your dotfiles repo into the VM
  config.vm.synced_folder ".", "/home/testuser/.dotfiles", type: "9p", accessmode: "mapped"
  
  # Configure libvirt provider for optimal performance
  config.vm.provider "libvirt" do |libvirt|
    # Resource allocation (adjust based on your host specs)
    libvirt.memory = 12288  # 12GB RAM
    libvirt.cpus = 8        # 8 CPU cores
    
    # VM identification
    libvirt.title = "Arch Linux Dotfiles Test Environment"
    libvirt.description = "Arch Linux VM for testing dotfiles with i3"
    
    # Graphics and display configuration
    libvirt.graphics_type = "spice"
    libvirt.graphics_autoport = "yes"
    libvirt.graphics_passwd = nil  # No password for easier access
    libvirt.video_type = "virtio"
    libvirt.video_vram = 131072    # 128MB video memory for higher resolutions
    libvirt.video_accel3d = "yes"
    
    # Enable automatic resolution adjustment
    libvirt.graphics_gl = "yes"
    
    # Audio configuration
    libvirt.sound_type = "ich9"
    
    # Spice agent for better desktop integration and auto-resolution
    libvirt.channel :type => 'spicevmc', :target_name => 'com.redhat.spice.0', :target_type => 'virtio'
    libvirt.channel :type => 'unix', :target_name => 'org.qemu.guest_agent.0', :target_type => 'virtio'
    
    # Performance optimizations
    libvirt.nested = true                    # Enable nested virtualization
    libvirt.cpu_mode = 'host-passthrough'   # Best CPU performance
    libvirt.machine_type = "q35"            # Modern machine type
    libvirt.disk_bus = "virtio"             # Faster disk I/O
    libvirt.nic_model_type = "virtio"       # Faster network
    
    # Random number generator for better entropy
    libvirt.random :model => 'random'
    
    # Additional storage if needed (uncomment to add a 50GB data disk)
    # libvirt.storage :file, :size => '50G', :type => 'qcow2', :bus => 'virtio'
    
    # USB redirection for better hardware support
    libvirt.usb_controller :model => 'nec-xhci', :ports => 8
    
    # Memory balloon for dynamic memory management
    libvirt.memorybacking :access, :mode => "shared"
  end
  
  # Pre-provision setup (runs before main provisioning)
  config.vm.provision "shell", name: "pre-setup", inline: <<-SHELL
    echo "🔧 Pre-setup: Optimizing pacman and fixing keyrings..."
    
    # Optimize pacman configuration
    sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
    sed -i 's/#Color/Color/' /etc/pacman.conf
    sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
    
    # Enable multilib repository for broader package support
    if ! grep -q "\\[multilib\\]" /etc/pacman.conf; then
      echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
    fi
    
    # Fix keyring issues (common Arch Linux VM problem)
    pacman-key --init
    pacman-key --populate archlinux
    pacman -Sy --noconfirm archlinux-keyring
    
    # Update package database
    pacman -Sy
  SHELL
  
  # Main system provisioning
  config.vm.provision "shell", name: "system-setup", inline: <<-SHELL
    echo "📦 Installing base system packages..."
    
    # System update with retry logic
    for i in {1..3}; do
      if pacman -Syu --noconfirm; then
        break
      else
        echo "Update attempt $i failed, retrying..."
        sleep 5
      fi
    done
    
    # Essential development tools
    pacman -S --noconfirm --needed \
      base-devel \
      git \
      wget \
      curl \
      unzip \
      vim \
      nano \
      htop \
      neofetch \
      tree \
      which \
      sudo
    
    echo "✅ Base system packages installed"
  SHELL
  
  # X11 and i3 installation
  config.vm.provision "shell", name: "x11-i3", inline: <<-SHELL
    echo "🖼️ Installing X11 and i3..."
    
    # Core X11 components
    pacman -S --noconfirm --needed \
      xorg-server \
      xorg-xinit \
      xorg-xauth \
      xorg-xrandr \
      xorg-xset \
      xorg-xsetroot \
      xorg-xprop \
      xorg-xwininfo
    
    # i3 window manager and essential components
    pacman -S --noconfirm --needed \
      i3-wm \
      i3status \
      i3lock \
      dmenu \
      xss-lock
    
    # Display manager
    pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter
    
    # SPICE guest tools for auto-resolution and better integration
    pacman -S --noconfirm --needed \
      spice-vdagent \
      qemu-guest-agent \
      mesa \
      mesa-utils \
      xf86-video-fbdev \
      xf86-video-vesa \
      xf86-video-qxl
    
    echo "✅ X11 and i3 installed"
  SHELL
  
  # Essential GUI applications
  config.vm.provision "shell", name: "gui-apps", inline: <<-SHELL
    echo "🎨 Installing GUI applications..."
    
    # Core GUI applications for X11/i3
    pacman -S --noconfirm --needed \
      rofi \
      alacritty \
      terminator \
      rxvt-unicode \
      dolphin \
      firefox \
      thunar \
      scrot \
      xclip \
      dunst \
      picom \
      feh \
      nitrogen
    
    # Optional: Install additional useful tools
    pacman -S --noconfirm --needed \
      networkmanager \
      network-manager-applet \
      bluez \
      bluez-utils \
      brightnessctl \
      playerctl \
      pavucontrol \
      arandr \
      lxappearance
    
    echo "✅ GUI applications installed"
  SHELL
  
  # Audio system setup
  config.vm.provision "shell", name: "audio-setup", inline: <<-SHELL
    echo "🔊 Setting up audio system..."
    
    # Install PipeWire audio stack
    pacman -S --noconfirm --needed \
      pipewire \
      pipewire-pulse \
      pipewire-alsa \
      pipewire-jack \
      wireplumber \
      alsa-utils
    
    echo "✅ Audio system configured"
  SHELL
  
  # Fonts and theming
  config.vm.provision "shell", name: "fonts-themes", inline: <<-SHELL
    echo "🎭 Installing fonts and themes..."
    
    # Essential fonts
    pacman -S --noconfirm --needed \
      ttf-dejavu \
      ttf-liberation \
      noto-fonts \
      noto-fonts-emoji \
      ttf-font-awesome \
      ttf-fira-code \
      ttf-fira-sans
    
    # Optional: Additional fonts for better coverage
    pacman -S --noconfirm --needed \
      adobe-source-code-pro-fonts \
      inter-font \
      cantarell-fonts
    
    # GTK themes and icons
    pacman -S --noconfirm --needed \
      gtk3 \
      gtk4 \
      adwaita-icon-theme \
      papirus-icon-theme \
      arc-gtk-theme \
      arc-icon-theme
    
    echo "✅ Fonts and themes installed"
  SHELL
  
  # User setup and configuration
  config.vm.provision "shell", name: "user-setup", inline: <<-SHELL
    echo "👤 Setting up user account..."
    
    # Create or ensure test user exists with proper groups
    if ! id "testuser" &>/dev/null; then
      useradd -m -G wheel,audio,video,input,storage -s /bin/bash testuser
      echo "testuser:password" | chpasswd
      echo "✅ User 'testuser' created with password 'password'"
    else
      echo "ℹ️ User 'testuser' already exists"
      # Add to groups if not already there
      usermod -aG wheel,audio,video,input,storage testuser
      echo "testuser:password" | chpasswd
      echo "✅ User 'testuser' password updated"
    fi
    
    # Fix ownership of home directory and contents
    chown -R testuser:testuser /home/testuser
    chmod 755 /home/testuser
    echo "✅ Fixed home directory ownership"
    
    # Configure sudo for wheel group
    if ! grep -q "^%wheel ALL=(ALL) NOPASSWD: ALL" /etc/sudoers; then
      echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
      echo "✅ Passwordless sudo configured for wheel group"
    fi
    
    # Set up basic shell and X11 session for testuser
    sudo -u testuser bash -c '
      # Create basic directories
      mkdir -p ~/.config ~/.local/bin ~/.local/share
      echo "✅ Created user directories"
      
      # Create basic .xinitrc to start i3
      cat > ~/.xinitrc << "EOF"
#!/bin/bash
# X11 session startup

# Load resources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Set background (fallback)
xsetroot -solid "#2e3440" &

# Start compositor for transparency and effects
picom -b &

# Start notification daemon
dunst &

# Start network manager applet
nm-applet &

# Start spice-vdagent for better VM integration
/usr/bin/spice-vdagent &

# Start i3 window manager
exec i3
EOF
      
      chmod +x ~/.xinitrc
      echo "✅ Created .xinitrc"
      
      # Create minimal .Xresources
      cat > ~/.Xresources << "EOF"
! Basic X11 resources
Xft.dpi: 96
Xft.antialias: true
Xft.rgba: rgb
Xft.hinting: true
Xft.hintstyle: hintslight

! URxvt settings
URxvt.font: xft:Fira Code:size=12
URxvt.background: #2e3440
URxvt.foreground: #d8dee9
URxvt.scrollBar: false
EOF
      echo "✅ Created .Xresources"
    '
    
    # Double-check permissions are correct
    chown -R testuser:testuser /home/testuser
    chmod 644 /home/testuser/.xinitrc /home/testuser/.Xresources
    chmod +x /home/testuser/.xinitrc
    
    echo "✅ User configuration completed"
  SHELL
  
  # Service configuration
  config.vm.provision "shell", name: "services", inline: <<-SHELL
    echo "⚙️ Configuring system services..."
    
    # Enable essential services
    systemctl enable lightdm
    systemctl enable NetworkManager
    systemctl enable bluetooth
    
    # Create LightDM config directory
    mkdir -p /etc/lightdm/lightdm.conf.d
    
    # Configure LightDM with better defaults (no auto-login initially)
    cat > /etc/lightdm/lightdm.conf.d/50-myconfig.conf << 'EOF'
[Seat:*]
session-wrapper=/etc/lightdm/Xsession
greeter-session=lightdm-gtk-greeter
allow-guest=false

[LightDM]
minimum-vt=7
EOF
    
    # Configure LightDM GTK greeter
    mkdir -p /etc/lightdm
    cat > /etc/lightdm/lightdm-gtk-greeter.conf << 'EOF'
[greeter]
theme-name=Adwaita
icon-theme-name=Adwaita
background=#2e3440
position=50%,center 50%,center
EOF
    
    # Create lightdm user and set proper permissions
    if ! id "lightdm" &>/dev/null; then
      useradd -r -g lightdm -d /var/lib/lightdm -s /usr/bin/nologin lightdm
    fi
    
    # Ensure proper directories and permissions exist
    mkdir -p /var/lib/lightdm
    mkdir -p /var/log/lightdm
    mkdir -p /run/lightdm
    
    chown -R lightdm:lightdm /var/lib/lightdm
    chown -R lightdm:lightdm /var/log/lightdm
    chmod 750 /var/lib/lightdm
    chmod 750 /var/log/lightdm
    
    # Set proper permissions on config files
    chmod 644 /etc/lightdm/lightdm.conf.d/50-myconfig.conf
    chmod 644 /etc/lightdm/lightdm-gtk-greeter.conf
    
    echo "✅ Services configured"
  SHELL
  
  # Final setup and information
  config.vm.provision "shell", name: "final-setup", inline: <<-SHELL
    echo "🎯 Final setup and optimizations..."
    
    # Update font cache
    fc-cache -fv
    
    # Update desktop database
    update-desktop-database
    
    # Clean package cache to save space
    pacman -Sc --noconfirm

    echo ""
    echo "🎉 ==============================================="
    echo "🎉  ARCH LINUX DOTFILES TEST VM READY!"
    echo "🎉 ==============================================="
    echo ""
    echo "📋 VM Information:"
    echo "   • Hostname: arch-dotfiles-test"
    echo "   • Username: testuser"
    echo "   • Password: password"
    echo "   • Desktop: i3 (X11)"
    echo ""
    echo "🚀 Next Steps:"
    echo "   1. Reboot the VM: vagrant reload"
    echo "   2. Access GUI: virt-viewer arch-dotfiles-test_default"
    echo "   3. Auto-login as testuser"
    echo "   4. Map your dotfiles config to ~/.config/i3/"
    echo ""
    echo "💡 Useful Commands:"
    echo "   • Clone your dotfiles: git clone <your-repo> ~/dotfiles"
    echo "   • Default terminal: alacritty"
    echo "   • App launcher: rofi (Mod+d)"
    echo "   • Lock screen: i3lock"
    echo ""
    echo "📁 Config locations for your dotfiles:"
    echo "   • i3 config: ~/.config/i3/config"
    echo "   • i3status: ~/.config/i3status/config"
    echo "   • rofi: ~/.config/rofi/"
    echo "   • alacritty: ~/.config/alacritty/"
    echo "   • dunst: ~/.config/dunst/"
    echo "   • picom: ~/.config/picom/"
    echo ""
    echo "🔄 Rebooting to complete setup..."
  SHELL
  
  # Auto-reboot after provisioning to ensure all services start properly
  # config.vm.provision "shell", name: "reboot", inline: "shutdown -r +1", run: "always"
end
