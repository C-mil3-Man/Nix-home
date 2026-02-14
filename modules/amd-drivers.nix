{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.drivers.amdgpu;
in {
  options.drivers.amdgpu = {
    enable = lib.mkEnableOption "Enable AMD Drivers";
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = ["L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"];
    services.xserver.videoDrivers = ["modesetting"];

    # OpenGL
    hardware.graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
      extraPackages = [
        pkgs.libva
        pkgs.libva-utils
      ];
    };
  };
}
