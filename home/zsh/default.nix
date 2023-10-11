{ config, lib, pkgs, self, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      up = "sudo nixos-rebuild switch --flake samu";
      fup = "sudo nixos-rebuild switch --flake samu --fast --builders ''";
      shell = "NIXPKGS_ALLOW_UNFREE=1 nix develop --impure";
      free-space = "sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system && sudo nix store gc --debug";
      # code = "codium --password-store=\"gnome\"";
      # rm = "trash put";

      ls = "eza --icons --group-directories-first";
      ll = "eza --icons --long --group --git --group-directories-first";
      la = "eza --icons --long --group --git --all --group-directories-first";
      tree = "eza --icons --tree --group-directories-first";

      c = "clear";
      q = "exit";
      rl = "omz reload";
      search = "nix search nixpkgs";
      find = "find -L";

      pwn = "shell ${self.outPath}#pwn";
      cpp = "nix develop ${self.outPath}#cpp";
      # shutdown = "sudo systemctl stop iptsd && shutdown";
      # reboot = "sudo systemctl stop iptsd && reboot";

      bat = "cat /sys/class/power_supply/BAT1/capacity";
      batt = "upower -i /org/freedesktop/UPower/devices/battery_BAT1";
      screenshot = "grim -g \"$(slurp)\"";
    };

    history = {
      size = 10000;
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
    initExtraFirst =
      ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';

    localVariables = {
      # remove the right side 1 char padding
      ZLE_RPROMPT_INDENT = "0";
    };
  };

  # needed config for zsh wakatime plugin
  home.sessionVariables.ZSH_WAKATIME_BIN = "${pkgs.wakatime}/bin/wakatime-cli";
}
