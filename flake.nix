{
  description = "Crux Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # Stable for system
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # Unstable for Zen Browser

    nixvim.url = "github:dc-tec/nixvim";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      sops-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      host = "wrkT14s";
      username = "crux";
    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit username;
            inherit host;
          };
          modules = [
            ./hosts/${host}/config.nix
            sops-nix.nixosModules.sops
          ];
        };
      };
    };
}
