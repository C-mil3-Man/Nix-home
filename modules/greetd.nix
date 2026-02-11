{pkgs, ...}: {
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = "/home/crux/Pictures/wallpapers/lainwp.jpg";
        fit = "Cover"; # or "Fill", "Contain", "ScaleDown"
      };
      GTK = {
        application_prefer_dark_theme = true;
      };
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.regreet}/bin/regreet";
        user = "greeter";
      };
    };
  };

  security.pam.services.greetd = {};
}
