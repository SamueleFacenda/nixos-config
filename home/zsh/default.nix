{ config, lib, pkgs, secrets, self, ... }: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    autocd = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      up = "nh os switch";
      fup = "nh os switch -- --builders ''";
      free-space = "home-manager expire-generations '-7 days' && sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system && sudo nix store gc --debug";
      # code = "codium --password-store=\"gnome\"";
      srm = "saferm";
      xcodium = "codium --enable-features=UseOzonePlatform --ozone-platform=x11";
      newnixbuildkey = "ssh-keygen -t ed25519 -f $HOME/.ssh/nixbuild && cat $HOME/.ssh/nixbuild.pub";
      nix-direnv-reload-force = "touch flake.nix && nix-direnv-reload";
      nix-unsec = "env NIXPKGS_ALLOW_INSECURE=1 nix --impure";

      tree = "eza --tree";
      # ls = lib.mkForce "eza --git-ignore";
      c = "clear";
      q = "exit";
      rl = "omz reload";
      search = "nix search --offline nixpkgs";
      find = "find -L";
      open = "xdg-open";
      readme = "mdcat README.md";
      whr = "grep -R --exclude-dir .direnv";
      ggr = "git grep --ignore-case";
      bright = "swayosd-client --brightness raise";
      dark = "swayosd-client --brightness lower";
      lum = "swayosd-client --brightness";
      img = "kitty +kitten icat";
      tmp = "cd $(mktemp --tmpdir -d $(diceware -d- -n2)-XXX)";
      tmpf = "micro $(mktemp --tmpdir $(diceware -d- -n2)-XXX -u)";
      logh =
        if secrets ? github-token
        then "sudo cat ${secrets.github-token.path} | gh auth login --with-token"
        else "gh auth login";

      ac = "sudo auto-cpufreq --force performance && sudo tlp ac";
      bat = "sudo auto-cpufreq --force powersave && sudo tlp bat";
      auto = "sudo auto-cpufreq --force reset && sudo tlp start";

      batt = "cat /sys/class/power_supply/BAT*/capacity";
      screenshot = "grim -g \"$(slurp)\"";
    };

    history = {
      size = 50000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    # plugins with oh-my-zsh
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "z"
      ];
      # theme = "robbyrussell";
    };

    # manual plugins
    plugins = [
      # note for everyone: running `function print(){ echo "$1" }` will break powerlevel10k and zsh-z (and other tools maybe), very hard to revert
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
      {
        name = "wakatime";
        src = pkgs.fetchFromGitHub {
          owner = "sobolevn";
          repo = "wakatime-zsh-plugin";
          rev = "69c6028b0c8f72e2afcfa5135b1af29afb49764a"; # latest commit as of 12 august 2023
          sha256 = "pA1VOkzbHQjmcI2skzB/OP5pXn8CFUz5Ok/GLC6KKXQ=";
        };
      }
    ];

    # enable p10k instant prompt
    initContent = lib.mkBefore
      ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';

    localVariables = {
      # remove the right side 1 char padding
      ZLE_RPROMPT_INDENT = "0";
      # some pasting problems, like slowness
      DISABLE_MAGIC_FUNCTIONS = "true";
      ZSH_AUTOSUGGEST_HISTORY_IGNORE = "cd *";
      # TODO find a way to use some other keybinding
      #ZSH_AUTOSUGGEST_ACCEPT_WIDGETS = "forward-char end-of-line vi-forward-char vi-end-of-line vi-add-eol";
    };
  };
  
  # Dependencies for aliases
  home.packages = with pkgs; [
    rusty-diceware
  ];

  # needed config for zsh wakatime plugin
  home.sessionVariables.ZSH_WAKATIME_BIN = "${pkgs.wakatime-cli}/bin/wakatime-cli";
}
