{ config, pkgs, lib, utils, disabledFiles, ... }:
let
  usr_bin_dir = "/home/samu/.local/bin/";
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
    playerctl

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
    ];
    settings = {

      exec-once = [
        "hyprpaper"
        "hyprctl setcursor Adwaita 24"
        #"${usr_bin_dir}waybar-loop" # waybar auto-reload
        "waybar" #normal waybar, I'm not working with the config right now
        "brave"
        "kitty"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "${usr_bin_dir}init-eww"
        # https://github.com/hyprwm/Hyprland/issues/2586
        # "${pkgs.systemd}/bin/systemctl --user try-reload-or-restart  kanshi.service"
        #"dunst"
      ];
    };
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
