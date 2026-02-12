{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = "${pkgs.tuigreet}/bin/tuigreet \
          --time \
          --time-format '%Y-%m-%d | %H:%M:%S' \
          --remember \
          --remember-user-session \
          --asterisks \
          --width 80 \
          --theme 'border=magenta;text=cyan;prompt=green;time=white;action=blue;button=yellow;container=black;input=gray' \
          --cmd Hyprland";
      };
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;
}
