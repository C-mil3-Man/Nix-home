{ pkgs, inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  #######################
  # System Packages    #
  #######################
  environment.systemPackages = (
    with pkgs;
    [
      # Core System Utilities
      btrfs-progs
      clang
      curl
      cpufrequtils
      git
      killall
      openssl # required by Rainbow borders
      pciutils
      vim
      wget
      dig

      # System Monitoring & Information
      btop
      duf
      eza
      fastfetch
      nvtopPackages.full
      dysk

      # Development Tools
      python3
      ansible
      bat
      lazygit
      openstackclient
      ripgrep
      s3cmd
      code-cursor

      # XDG and Desktop Integration
      glib # for gsettings to work
      gsettings-qt
      libappindicator
      libnotify
      xdg-user-dirs
      xdg-utils

      # Multimedia
      ffmpeg
      (mpv.override { scripts = [ mpvScripts.mpris ]; }) # with tray
      #ranger

      # Hyprland and Wayland Specific
      brightnessctl # for brightness control
      cava
      cliphist
      loupe
      grim
      gtk-engine-murrine # for gtk themes
      hypridle # requires unstable channel
      imagemagick
      jq
      kitty
      networkmanagerapplet
      nwg-look
      pamixer
      pavucontrol
      playerctl
      polkit_gnome
      pyprland
      rofi-wayland
      slurp
      swappy
      swaynotificationcenter
      swww
      wallust
      wl-clipboard
      wlogout
      yad

      # Qt/KDE Integration
      libsForQt5.qtstyleplugin-kvantum # kvantum
      libsForQt5.qt5ct
      kdePackages.qt6ct
      kdePackages.qtwayland
      kdePackages.qtstyleplugin-kvantum # kvantum

      # File Management
      unzip
      xarchiver

      # Other
      bitwarden-desktop
      signal-desktop
      yt-dlp
      teams-for-linux
      vesktop
      colmena
      sops
      inputs.zen-browser.packages."${system}".default
      networkmanager
      xl2tpd
      strongswan
      inputs.nixvim.packages.${pkgs.system}.default

      #waybar  # if wanted experimental next line
      #(pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))
    ]
  );

  #######################
  # Fonts              #
  #######################
  fonts.packages = with pkgs; [
    # Regular Fonts
    noto-fonts
    noto-fonts-cjk-sans
    fira-code
    fira-code-symbols
    hackgen-nf-font
    material-icons
    powerline-fonts
    jetbrains-mono
    font-awesome
    terminus_font
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.jetbrains-mono
    adwaita-icon-theme
    # Nerd Fonts
    #(nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) # stable branch
    #(nerdfonts.override { fonts = [ "FantasqueSansMono" ]; }) # stable branch
    #nerd-fonts.jetbrains-mono # unstable
    #nerd-fonts.fira-code # unstable
  ];

  #######################
  # Programs           #
  #######################
  programs = {
    # Desktop Environment
    hyprland = {
      enable = true;
      #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; #hyprland-git
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };
    waybar.enable = true;
    hyprlock.enable = true;
    xwayland.enable = true;

    direnv.enable = true;

    # Applications
    firefox.enable = true;
    git.enable = true;
    #neovim.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        exo
        mousepad
        thunar-archive-plugin
        thunar-volman
        tumbler
      ];
    };

    # System Utilities
    nm-applet.indicator = true;
    dconf.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;

    # Security
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # Gaming
    virt-manager.enable = false;
    #steam = {
    #  enable = true;
    #  gamescopeSession.enable = true;
    #  remotePlay.openFirewall = true;
    #  dedicatedServer.openFirewall = true;
    #};
  };

  #######################
  # XDG Portal         #
  #######################
  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
  };
}
