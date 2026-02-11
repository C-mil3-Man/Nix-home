{
  description = "Crux Nix";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # Stable for system
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    alejandra,
    sops-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    host = "wrkT14s";
    username = "crux";

    # Centralized pkgs with overlays
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowBroken = true; # Allow broken packages (temporary fix for broken CUDA in nixos-unstable)
      };
    };

    # Common special args for all configurations
    specialArgs = {
      inherit system inputs username host;
    };
  in {
    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      inherit specialArgs;

      modules = [
        # Host-specific configuration
        ./hosts/${host}/config.nix

        # Secrets management
        sops-nix.nixosModules.sops

        # System modules
        # inputs.distro-grub-themes.nixosModules.${system}.default
        #./modules/overlays.nix # nixpkgs overlays (CMake policy fixes)
        ./modules/quickshell.nix # quickshell module
        ./modules/packages.nix # Software packages
        ./modules/fonts.nix # Fonts packages
        ./modules/portals.nix # portal
        ./modules/theme.nix # Set dark theme
        ./modules/greetd.nix # greetd basic

        # Catppuccin theming
        inputs.catppuccin.nixosModules.catppuccin

        # Home Manager integration
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;

            users.${username} = {
              home = {
                inherit username;
                homeDirectory = "/home/${username}";
                stateVersion = "24.05";
              };

              # Import your copied HM modules
              imports = [
                ./modules/home/default.nix
              ];
            };
          };
        }
      ];
    };

    # Code formatter
    formatter.${system} = alejandra.defaultPackage.${system};
  };
}
