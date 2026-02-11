{pkgs, ...}: {
  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        user = "greeter";
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --remember \
          --remember-user-session \
          --asterisks \
          --cmd Hyprland";
      };
    };
  };

  # Required for greetd login
  security.pam.services.greetd = {};
}
