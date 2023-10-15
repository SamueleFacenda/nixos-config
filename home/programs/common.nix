{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
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

    # misc
    xdg-utils
    tree
    wakatime
    spotify-tui
    editorconfig-core-c
    gnome.adwaita-icon-theme
    wf-recorder
    fonttools

    # productivity
    obsidian
    xournalpp

    # web
    brave

    # code
    (python3.withPackages (ps: with ps; [
      pillow # for ranger kitty image preview
      icecream
      # ranger deps
      chardet
      python-bidi
    ]))

    # ranger dependencies
    file
    libcaca
    imagemagick
    librsvg
    ffmpegthumbnailer
    highlight
    atool
    libarchive
    unrar
    lynx
    poppler_utils
    # djvulibre
    # calibre
    # transmission-qt
    exiftool
    odt2txt
    fontforge
    # openscad
    # drawio
  ];

  programs = {
    btop.enable = true; # replacement of htop/nmon
    eza.enable = true; # A modern replacement for ‘ls’
    ssh.enable = true;
  };

  services = {
    # syncthing.enable = true;

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
