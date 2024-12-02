{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
    home-manager
    nix-output-monitor

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
    seahorse
    mediawriter
    rlwrap
    gparted
    gnome-disk-utility

    # misc
    xdg-utils
    wakatime
    editorconfig-core-c
    # gnome.adwaita-icon-theme
    wf-recorder
    # fonttools

    # productivity
    obsidian
    xournalpp

    # web/social
    brave
    # telegram-desktop
    # discord
    # whatsapp-for-linux
    zoom-us
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

  services.udiskie = {
    # auto mount usb drives
    enable = true;
    tray = "always";
    settings.program_options.file_manager = "${pkgs.xdg-utils}/bin/xdg-open";
  };

  # fix udiskie problem
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
