{ config, pkgs, lib, ... }: {

  imports = [
    ./dunst.nix
    ./waybar
    ./hyprpaper.nix
    ./shana.nix
    ./swayidle.nix
    ./kanshi.nix
  ];

  home.packages = with pkgs; [
    gtk3
    swaylock-effects
    hyprpaper
    wofi

    # screenshots tools
    slurp
    grim
    # pamixer

    #utilities
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
      #hyprgrass
    ];
    settings =
      import ./bindings.nix //
      import ./settings.nix lib // {

        exec-once = [
          "hyprpaper"
          "/home/samu/.local/bin/waybar-loop" # waybar auto-reload
          "brave"
          "kitty"
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "hyprctl setcursor Adwaita 24"
          "eww daemon"
          # https://github.com/hyprwm/Hyprland/issues/2586
          # "${pkgs.systemd}/bin/systemctl --user try-reload-or-restart  kanshi.service"
          #"dunst"
        ];
      };
  };

  services.swayosd.enable = true;
  services.swayosd.maxVolume = 150;

  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ./eww;
  };
}
