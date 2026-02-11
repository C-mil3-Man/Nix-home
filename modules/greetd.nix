{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.regreet}/bin/regreet";
        user = "greeter";
      };
    };
  };

  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = "/usr/share/wallpapers/lainwp.jpg";
        fit = "Cover";
      };
      GTK = {
        application_prefer_dark_theme = true;
      };
    };
  };

  # Ensure greeter user has proper environment
  environment.systemPackages = with pkgs; [cage];

  security.pam.services.greetd.enableGnomeKeyring = true;
}
