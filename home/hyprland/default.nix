{ config, pkgs, lib, utils, disabledFiles, ... }:
{

  imports = utils.listDirPathsExcluding (disabledFiles ++ [ "dunst.nix" ]) ./.;

  home.packages = with pkgs; [
    wofi
    wvkbd
    libinput
    # hyprswitch

    # screenshots tools
    slurp
    grim

    # audio video
    pamixer
    pavucontrol
    playerctl

    # displays
    wlr-randr
    nwg-displays
    nwg-bar
    hyprshade

    # utilities
    nautilus
    eog
    file-roller
    totem
    lollypop # gnome audio player

    # screen recorder via xdg-desktop-portal
    kooha
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    maxNWorkspaces = 6;
    plugins = with pkgs.hyprlandPlugins; [
      # hyprfocus # animation on focus change TODO wait for build fix
      # hyprspace
      # hyprexpo # hyprctl dispatch hyprexpo:expo toggle
    ];
    settings.exec-once = [
      "hyprctl setcursor Adwaita 24"
      "brave"
      "kitty"
      "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    ];
  };

  services.gnome-keyring.enable = true;

  services.swayosd.enable = true;
}
