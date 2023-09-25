{ config, pkgs, lib, ... }: {

  imports = [
    ./dunst.nix
    ./waybar
    ./wofi
    ./hyprpaper.nix
    ./shana.nix
    ./swayidle.nix
    ./kanshi.nix
  ];

  home.packages = with pkgs; [
    gtk3
    swayidle
    swaylock-effects
    hyprpaper
    slurp
    grim
    pamixer
    gnome.nautilus
    gnome.eog
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs; [
      hyprgrass
    ];
    settings =
      import ./bindings.nix //
      import ./settings.nix lib // {

        exec-once = [
          "/home/samu/.local/bin/waybar-loop" # waybar auto-reload
          "brave"
          "kitty"
          "hyprpaper"
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          #"dunst"
        ];
      };

  };
}
