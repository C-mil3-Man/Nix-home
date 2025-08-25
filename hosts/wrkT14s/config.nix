{
  config,
  pkgs,
  host,
  username,
  options,
  lib,
  inputs,
  system,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./users.nix
    ./packages-fonts.nix
    ../../modules/amd-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
  ];

  #######################
  # Boot Configuration #
  #######################
  boot = {
    kernelPackages = pkgs.linuxPackages_zen; # Kernel
    #kernelPackages = pkgs.linuxPackages_latest; # Kernel

    kernelParams = [
      "systemd.mask=systemd-vconsole-setup.service"
      "systemd.mask=dev-tpmrm0.device" # this is to mask that stupid 1.5 mins systemd bug
      "nowatchdog"
      "quiet"
      "splash"
      "modprobe.blacklist=sp5100_tco" # watchdog for AMD
    ];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "amdgpu"
      ];
      kernelModules = [ ];
    };

    # Bootloader SystemD
    loader = {
      systemd-boot.enable = true;
      efi = {
        #efiSysMountPoint = "/efi"; #this is if you have separate /efi partition
        canTouchEfiVariables = true;
      };
      timeout = 1;
    };

    # Make /tmp a tmpfs
    tmp = {
      cleanOnBoot = true;
      useTmpfs = false;
      tmpfsSize = "30%";
    };

    plymouth.enable = true;
    plymouth.theme = "spinner";
  };

  ########################
  # System Configuration #
  ########################

  # Module Options
  drivers.amdgpu.enable = true;
  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;

  # System State Version
  system.stateVersion = "25.05"; # Did you read the comment?

  # Nix Settings
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  ######################
  # Network & Time    #
  ######################
  networking = {
    networkmanager = {
      enable = true;
      enableStrongSwan = true;
    };
    hostName = "${host}";
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    # firewall configuration
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # firewall.enable = false;
  };

  # Time Services
  #services.automatic-timezoned.enable = true; #based on IP location
  time.timeZone = "Europe/Stockholm"; # Set local timezone

  ######################
  # Localization      #
  ######################
  i18n = {
    defaultLocale = "en_US.UTF-8";

    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "sv_SE.UTF-8/UTF-8"
    ];

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  ######################
  # Hardware Settings #
  ######################
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
  };

  # Power Management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  # ZRAM Configuration
  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 30;
    swapDevices = 1;
    algorithm = "zstd";
  };

  ######################
  # System Services   #
  ######################
  services = {
    # Display Server
    xserver = {
      enable = false;
      videoDrivers = [ "amdgpu" ];
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Login Manager
    greetd = {
      enable = true;
      settings = {
        default_session = {
          user = username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
      };
    };

    # System Services
    smartd = {
      enable = false;
      autodetect = true;
    };
    gvfs.enable = true;
    tumbler.enable = true;
    udev.enable = true;
    envfs.enable = true;
    dbus.enable = true;
    libinput.enable = true;
    rpcbind.enable = false;
    openssh.enable = true;
    flatpak.enable = false;
    blueman.enable = true;
    fwupd.enable = true;
    upower.enable = true;
    gnome.gnome-keyring.enable = true;

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    # Storage
    fstrim = {
      enable = true;
      interval = "weekly";
    };
  };

  ######################
  # Security Settings #
  ######################
  security = {
    rtkit.enable = true;
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        })
      '';
    };
    pam.services.swaylock.text = ''
      auth include login
    '';
  };

  ######################
  # Virtualization    #
  ######################
  virtualisation = {
    libvirtd.enable = false;
    podman = {
      enable = false;
      dockerCompat = false;
      defaultNetwork.settings.dns_enabled = false;
    };
  };

  ######################
  # Environment       #
  ######################
  environment.sessionVariables = {
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = "0";
    BROWSER = "firefox";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  # This gets around the issue for my vpn not being able to initialize
  environment.etc."strongswan.conf".text = ''
    charon {
      load_modular = yes;
      plugins {
        integrity {
          load = no;
        }
      }
    }
  '';
}
