{
  pkgs,
  inputs,
  host,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  programs = {
    hyprland = {
      enable = true;
      withUWSM = false;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };

    zsh.enable = true;
    firefox.enable = false;
    waybar.enable = false; # handled externally
    hyprlock.enable = true;
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    direnv.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    git.enable = true;
    nm-applet.indicator = true;

    neovim = {
      enable = true;
      defaultEditor = false;
    };

    thunar = {
      enable = true;
      plugins = [
        pkgs.xfce4-exo
        pkgs.mousepad
        pkgs.thunar-archive-plugin
        pkgs.thunar-volman
        pkgs.tumbler
      ];
    };
  };

  environment.systemPackages = [
    # Update flake script
    (pkgs.writeShellScriptBin "update" ''
      cd ~/nix-home
      nh os switch -u -H ${host} .
    '')
    # Rebuild flake script
    (pkgs.writeShellScriptBin "rebuild" ''
      cd ~/nix-home
      nh os switch -H ${host} .
    '')
    # clean up old generations
    (pkgs.writeShellScriptBin "ncg" ''
      nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot
    '')

    ##############################
    # Core System Utilities   #
    ##############################
    pkgs.alejandra # Formatter
    pkgs.curl # Command-line data transfer tool
    pkgs.wget # File downloader
    pkgs.dig # DNS lookup tool
    pkgs.git # Version control
    pkgs.killall # Kill processes by name
    pkgs.openssl # Crypto toolkit, required by Hyprland rainbow borders
    pkgs.pciutils # PCI device info tools
    pkgs.btrfs-progs # Btrfs filesystem utilities
    pkgs.cpufrequtils # CPU frequency control
    pkgs.lm_sensors # Hardware sensor readings
    pkgs.light # Screen brightness control
    pkgs.unzip # Extract zip archives
    pkgs.xarchiver # GUI archive manager
    pkgs.ncdu # Disk usage viewer
    pkgs.findutils # Basic Unix find/xargs
    pkgs.gnumake # Build automation tool
    pkgs.cargo
    #pkgs.gcc # C compiler
    #pkgs.clang # C/C++/ObjC compiler
    #pkgs.cmake # Build system generator
    pkgs.jq # JSON processor
    pkgs.ripgrep # Fast grep replacement
    pkgs.bat # Syntax-highlighted `cat`
    pkgs.fd # Fast alternative to `find`
    pkgs.dua # Disk usage analyzer
    pkgs.duf # Disk usage/free utility
    pkgs.socat # Data relay and TCP proxy
    pkgs.tldr # Simplified man pages
    pkgs.zoxide # Smarter directory jumping
    pkgs.starship # Cross-shell prompt
    pkgs.oh-my-posh # Shell prompt theme engine
    pkgs.neofetch # System info in terminal
    pkgs.fastfetch # Fast system info CLI
    pkgs.dysk # Disk usage visualizer
    pkgs.eza # Modern `ls` replacement
    pkgs.figlet # ASCII art text generator
    pkgs.cmatrix # Matrix terminal effect
    pkgs.file-roller # Archive manager
    pkgs.smartmontools # SMART disk monitoring
    pkgs.ipfetch # Network info fetcher
    pkgs.gping # Graphical ping
    pkgs.gdu # Disk usage analyzer (TUI)
    pkgs.ncftp # FTP client

    ###################################
    # Development & DevOps Tools #
    ###################################
    pkgs.python3 # Python interpreter
    pkgs.ansible # IT automation
    pkgs.luarocks # Lua package manager
    pkgs.nh # Nix helper tool
    pkgs.colmena # NixOS deployment tool
    pkgs.deploy-rs # Secondary deployment tool
    pkgs.sops # Secret management
    pkgs.openstackclient # OpenStack CLI
    pkgs.s3cmd # S3-compatible storage client
    pkgs.code-cursor # VSCode Cursor edition
    pkgs.lazygit # TUI Git client
    pkgs.gh # GitHub CLI
    pkgs.lazyjournal # TUI for journalctl
    pkgs.direnv
    pkgs.vscodium-fhs
    pkgs.gemini-cli

    ##################################
    # Networking / VPN / Internet #
    ##################################
    pkgs.networkmanagerapplet # NetworkManager tray app
    pkgs.networkmanager-l2tp # Network management daemon
    pkgs.xl2tpd # L2TP VPN daemon
    pkgs.strongswan # IPsec VPN client
    pkgs.wget # HTTP downloader
    pkgs.curl # URL data fetcher
    pkgs.vesktop # Electron Discord wrapper
    pkgs.teams-for-linux # Microsoft Teams desktop client
    pkgs.signal-desktop # Secure messenger
    pkgs.bitwarden-desktop # Password manager
    inputs.zen-browser.packages.${pkgs.system}.default # Zen browser

    ##############################
    # Hyprland / Wayland Apps #
    ##############################
    pkgs.hypridle # Idle daemon for Hyprland
    pkgs.hyprpolkitagent # Polkit agent for Hyprland
    pkgs.pyprland # Hyprland Python automation
    pkgs.hyprlang # Hyprland config parser
    pkgs.hyprshot # Screenshot tool for Hyprland
    pkgs.hyprcursor # Cursor theme support
    pkgs.mesa # OpenGL/Mesa drivers
    pkgs.nwg-displays # Display layout GUI for wlroots
    pkgs.nwg-look # GTK/Qt theme switcher
    pkgs.waypaper # Wallpaper manager
    pkgs.hyprland-qt-support # QT integration helper
    pkgs.kdePackages.polkit-kde-agent-1 # KDE Polkit agent
    pkgs.swaynotificationcenter # Notification daemon
    pkgs.waybar # Status bar
    pkgs.wl-clipboard # Wayland clipboard
    pkgs.wlr-randr # Wayland display manager
    pkgs.wlogout # Logout menu
    pkgs.slurp # Select region for screenshots
    pkgs.grim # Screenshot utility
    pkgs.grimblast # Hyprland screenshot helper
    pkgs.swappy # Screenshot annotation
    pkgs.wallust # Generate colorschemes from wallpaper
    pkgs.swww # Wallpaper daemon
    pkgs.yad # GTK dialog builder
    pkgs.rofi # App launcher (Wayland compatible)
    pkgs.cava # Audio visualizer
    pkgs.pamixer # Audio volume control
    pkgs.pavucontrol # GUI volume mixer
    pkgs.playerctl # Media player control
    pkgs.glib # GSettings base library
    pkgs.gsettings-qt # GSettings integration for Qt
    pkgs.gtk-engine-murrine # GTK theme engine
    pkgs.libappindicator # System tray support
    pkgs.libnotify # Notification library
    pkgs.kitty # Terminal emulator

    ###################################
    # Multimedia / GUI Applications #
    ###################################
    pkgs.ffmpeg # Multimedia framework
    pkgs.vlc # Video player
    (pkgs.mpv.override {scripts = [pkgs.mpvScripts.mpris];}) # Video player with MPRIS
    pkgs.loupe # Image viewer
    pkgs.eog # GNOME image viewer
    pkgs.feh # Lightweight image viewer
    pkgs.appimage-run # Run AppImage apps
    pkgs.gnome-system-monitor # Process viewer GUI
    pkgs.baobab # Disk usage analyzer (GUI)
    pkgs.wdisplays # Display configuration GUI
    pkgs.bc

    ##############################
    # Virtualization Tools    #
    ##############################
    pkgs.virt-viewer # SPICE/VNC VM viewer
    pkgs.libvirt # Virtualization management daemon

    ##############################
    # Extra Packages          #
    ##############################
    inputs.quickshell.packages.${pkgs.system}.default
  ];
}
