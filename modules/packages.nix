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

  environment.systemPackages = with pkgs; [
    # Update flake script
    (writeShellScriptBin "update" ''
      cd ~/nix-home
      nh os switch -u -H ${host} .
    '')
    # Rebuild flake script
    (writeShellScriptBin "rebuild" ''
      cd ~/nix-home
      nh os switch -H ${host} .
    '')
    # clean up old generations
    (writeShellScriptBin "ncg" ''
      nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot
    '')

    ##############################
    # Core System Utilities   #
    ##############################
    alejandra # Formatter
    curl # Command-line data transfer tool
    wget # File downloader
    dig # DNS lookup tool
    git # Version control
    killall # Kill processes by name
    openssl # Crypto toolkit, required by Hyprland rainbow borders
    pciutils # PCI device info tools
    btrfs-progs # Btrfs filesystem utilities
    cpufrequtils # CPU frequency control
    lm_sensors # Hardware sensor readings
    light # Screen brightness control
    unzip # Extract zip archives
    xarchiver # GUI archive manager
    ncdu # Disk usage viewer
    findutils # Basic Unix find/xargs
    gnumake # Build automation tool
    cargo
    #gcc # C compiler
    #clang # C/C++/ObjC compiler
    #cmake # Build system generator
    jq # JSON processor
    ripgrep # Fast grep replacement
    bat # Syntax-highlighted `cat`
    fd # Fast alternative to `find`
    dua # Disk usage analyzer
    duf # Disk usage/free utility
    socat # Data relay and TCP proxy
    tldr # Simplified man pages
    zoxide # Smarter directory jumping
    starship # Cross-shell prompt
    oh-my-posh # Shell prompt theme engine
    neofetch # System info in terminal
    fastfetch # Fast system info CLI
    dysk # Disk usage visualizer
    eza # Modern `ls` replacement
    figlet # ASCII art text generator
    cmatrix # Matrix terminal effect
    file-roller # Archive manager
    smartmontools # SMART disk monitoring
    ipfetch # Network info fetcher
    gping # Graphical ping
    gdu # Disk usage analyzer (TUI)
    ncftp # FTP client

    ###################################
    # Development & DevOps Tools #
    ###################################
    python3 # Python interpreter
    ansible # IT automation
    luarocks # Lua package manager
    nh # Nix helper tool
    colmena # NixOS deployment tool
    deploy-rs # Secondary deployment tool
    sops # Secret management
    openstackclient # OpenStack CLI
    s3cmd # S3-compatible storage client
    code-cursor # VSCode Cursor edition
    lazygit # TUI Git client
    gh # GitHub CLI
    lazyjournal # TUI for journalctl
    direnv
    vscodium-fhs
    gemini-cli

    ##################################
    # Networking / VPN / Internet #
    ##################################
    networkmanagerapplet # NetworkManager tray app
    networkmanager-l2tp # Network management daemon
    xl2tpd # L2TP VPN daemon
    strongswan # IPsec VPN client
    wget # HTTP downloader
    curl # URL data fetcher
    vesktop # Electron Discord wrapper
    teams-for-linux # Microsoft Teams desktop client
    signal-desktop # Secure messenger
    bitwarden-desktop # Password manager
    inputs.zen-browser.packages."${system}".default # Zen browser

    ##############################
    # Hyprland / Wayland Apps #
    ##############################
    hypridle # Idle daemon for Hyprland
    hyprpolkitagent # Polkit agent for Hyprland
    pyprland # Hyprland Python automation
    hyprlang # Hyprland config parser
    hyprshot # Screenshot tool for Hyprland
    hyprcursor # Cursor theme support
    mesa # OpenGL/Mesa drivers
    nwg-displays # Display layout GUI for wlroots
    nwg-look # GTK/Qt theme switcher
    waypaper # Wallpaper manager
    hyprland-qt-support # QT integration helper
    kdePackages.polkit-kde-agent-1 # KDE Polkit agent
    swaynotificationcenter # Notification daemon
    waybar # Status bar
    wl-clipboard # Wayland clipboard
    wlr-randr # Wayland display manager
    wlogout # Logout menu
    slurp # Select region for screenshots
    grim # Screenshot utility
    grimblast # Hyprland screenshot helper
    swappy # Screenshot annotation
    wallust # Generate colorschemes from wallpaper
    swww # Wallpaper daemon
    yad # GTK dialog builder
    rofi # App launcher (Wayland compatible)
    cava # Audio visualizer
    pamixer # Audio volume control
    pavucontrol # GUI volume mixer
    playerctl # Media player control
    glib # GSettings base library
    gsettings-qt # GSettings integration for Qt
    gtk-engine-murrine # GTK theme engine
    libappindicator # System tray support
    libnotify # Notification library
    kitty # Terminal emulator

    ###################################
    # Multimedia / GUI Applications #
    ###################################
    ffmpeg # Multimedia framework
    vlc # Video player
    (mpv.override {scripts = [mpvScripts.mpris];}) # Video player with MPRIS
    loupe # Image viewer
    eog # GNOME image viewer
    feh # Lightweight image viewer
    appimage-run # Run AppImage apps
    gnome-system-monitor # Process viewer GUI
    baobab # Disk usage analyzer (GUI)
    wdisplays # Display configuration GUI
    bc
    lutris

    ##############################
    # Virtualization Tools    #
    ##############################
    virt-viewer # SPICE/VNC VM viewer
    libvirt # Virtualization management daemon

    ##############################
    # Extra Packages          #
    ##############################
    inputs.ags.packages.${pkgs.system}.default
    inputs.quickshell.packages.${pkgs.system}.default
  ];
}
