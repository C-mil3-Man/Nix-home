{ pkgs, username, ... }:

{
  users = {
    mutableUsers = true;
    users."${username}" = {
      homeMode = "755";
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "video"
        "input"
        "audio"
      ];
    };

    defaultUserShell = pkgs.zsh;
  };

  environment.shells = with pkgs; [ zsh ];
  environment.systemPackages = with pkgs; [ fzf ];

  programs = {
    # Zsh configuration
    zsh = {
      enable = true;
      enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "colored-man-pages"
        ];
        theme = "xiong-chiamiov-plus";
      };

      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      #fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc
      promptInit = ''

        source <(fzf --zsh);
        HISTFILE=~/.zsh_history;
        HISTSIZE=10000;
        SAVEHIST=10000;
        setopt appendhistory;
      '';
    };
  };
}
