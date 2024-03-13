{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
    home-manager

    # archives
    zip
    unzip
    p7zip

    # utils
    mdcat
    xclip
    rpl
    statix
    nixpkgs-fmt
    ffmpeg
    # flameshot # https://github.com/flameshot-org/flameshot/issues/2978
    jq
    python312
    gnome.seahorse
    mediawriter
    rlwrap

    # misc
    xdg-utils
    wakatime
    spotify-player
    editorconfig-core-c
    gnome.adwaita-icon-theme
    wf-recorder
    # fonttools

    # productivity
    obsidian
    xournalpp

    # web
    brave
  ];

  programs = {
    btop.enable = true; # replacement of htop/nmon
    eza = {
      enable = true; # A modern replacement for ‘ls’
      icons = true;
      extraOptions = [
        "--group-directories-first"
        # "--git-ignore"
        "--header"
        "--group"
        # "--total-size"
      ];
    };
  };

  services = {
    # auto mount usb drives
    udiskie.enable = true;
    udiskie.settings.program_options = {
      file_manager = "${pkgs.xdg-utils}/bin/xdg-open";
      tray = false;
    };
  };

  # fix udiskie problem
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
