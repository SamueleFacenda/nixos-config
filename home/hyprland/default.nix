{ config, pkgs, lib, utils, disabledFiles, ... }:
{

  imports = utils.listDirPathsExcluding disabledFiles ./.;

  home.packages = with pkgs; [
    wofi
    wvkbd
    libinput

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

    # utilities
    gnome.nautilus
    gnome.eog
    gnome.file-roller
    lollypop # gnome audio player

    # screen recorder via xdg-desktop-portal
    kooha
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs; [
      hyprgrass # touch gestures
      # hyprfocus # animation on focus change Wait for fork to be buildable
      hycov # toggle overview
      hyprland-virtual-desktops # gnome-like workspaces behaviour
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
