{
  programs.zsh = {
    enable = true;
    initContent = ''
      # JSON validation helper
      checkjson() {
        if jq -e . "$1" >/dev/null 2>&1; then
          echo "✅ JSON is valid"
        else
          jq . "$1" >/dev/null
          echo "❌ JSON is invalid"
        fi
      }

      # Search for term in multiServer.json across local branches only
      gitsr() {
        if [ -z "$1" ]; then
          echo "Usage: gitsr <search_term>"
          return 1
        fi

        local search_term="$1"
        local file="multiServer.json"

        echo "Searching for: \"$search_term\" in $file (local branches only)"
        echo ""

        git for-each-ref --format='%(refname:short)' refs/heads/ | while read -r branch; do
          if git show "$branch:$file" 2>/dev/null | grep -qi "$search_term"; then
            echo "✔ Found in branch: $branch"
            git show "$branch:$file" | grep --color=always -i "$search_term" | sed 's/^/  > /'
            echo ""
          fi
        done
      }
    '';
  };

  programs.eza = {
    enable = true;
    icons = "auto";
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--no-quotes"
      "--header" # Show header row
      "--git-ignore"
      # "--time-style=long-iso" # ISO 8601 extended format for time
      "--classify" # append indicator (/, *, =, @, |)
      "--hyperlink" # make paths clickable in some terminals
    ];
  };

  # Ansible Vault key
  home.sessionVariables = {
    ANSIBLE_VAULT_PASSWORD_FILE = "$HOME/.ansible/password";
  };

  # Aliases to make `ls`, `ll`, `la` use eza
  home.shellAliases = {
    ":q" = "exit";
    sv = "sudo nvim";
    v = "nvim";
    c = "clear";
    ls = "eza";
    lt = "eza --tree --level=2";
    ll = "eza  -a --no-user --long";
    la = "eza -lah ";
    lsbc = "lsblk -f | bat -l conf -p ";
    tree = "eza --tree ";
    d = "exa -a --grid ";
    dir = "exa -a --grid";
    jctl = "journalctl -p 3 -xb";
    notes = "nvim ~/notes.txt";
    ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
    man = "batman";
    dysk = "dysk -c label+default";
    #zi = "cdi"; # for zoxide compatibilty
    serie = "serie -p kitty --preload -g double";

    cat = "bat -p";
    lg = "lazygit";
    ap = "ansible-playbook";
    oscc = "openstack --os-cloud cleura";
    osovh = "openstack --os-cloud ovh";
  };
}
