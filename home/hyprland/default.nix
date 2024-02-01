{ config, pkgs, lib, utils, disabledFiles, ... }:
let
  usr_bin_dir = "${config.home.homeDirectory}/.local/bin/";
in
{

  imports = utils.listDirPathsExcluding ([ "eww" ] ++ disabledFiles) ./.;

  home.packages = with pkgs; [
    gtk3
    swaylock-effects
    hyprpaper
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
      hyprgrass
      hyprfocus
      hycov
      hyprland-virtual-desktops
    ];
    settings.exec-once = [
      "hyprctl setcursor Adwaita 24"
      "brave"
      "kitty"
      "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      "${usr_bin_dir}init-eww"
      "swayosd-server" # waiting for https://github.com/nix-community/home-manager/pull/4881 merge...
    ];
  };

  services.gnome-keyring.enable = true;

  services.swayosd.enable = true;
  services.swayosd.maxVolume = 150;

  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ./eww;
  };
}
