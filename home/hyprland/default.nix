{ config, pkgs, lib, ... }: {

  imports = [
    ./dunst.nix
    ./waybar
    ./wofi
    ./hyprpaper.nix
    ./shana.nix

    ./settings.nix
    ./style.nix
  ];

  home.packages = with pkgs; [
    gtk3
    swayidle
    swaylock-effects
    hyprpaper
    slurp
    grim
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs; [
      hyprgrass
    ];
    settings =
      import ./bindings.nix //
      import ./settings.nix // {

        exec-once = [
          "/home/samu/.scripts/waybar.sh" # waybar auto-reload
          "brave"
          "kitty"
          "/home/samu/.scripts/sleep.sh" # auto suspend
          "hyprpaper"
          #"dunst"
        ];
      };

  };
}
