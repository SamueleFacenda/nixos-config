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
    nixd
    nixpkgs-fmt
    ffmpeg
    flameshot
    jq
    python312
    gnome.seahorse

    # misc
    xdg-utils
    wakatime
    spotify-tui
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
      ];
      enableAliases = true;
    };
    ssh.enable = true;
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
