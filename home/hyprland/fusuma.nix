{ config, lib, pkgs, ... }: {
  services.fusuma = {
    enable = true;
    extraPackages = with pkgs; [
      hyprland
      hyprswitch
      coreutils
    ];
    settings = {
      threshold = {
        swipe = 0.2;
      };
      interval = {
        swipe = 1;
      };
      swipe = {
        "3" = {
          # workspace swipe
          right.command = "hyprctl dispatch workspace r-1";
          left.command = "hyprctl dispatch workspace r+1";
          # enter exit overview (additional commands)

          up.command = "hyprswitch --daemon";
          down.command = "hyprswitch --stop-daemon";
        };
        "4" = {
          # overview enter and navigation
          # left.update = {
          #   command = "hyprswitch -r";
          #   interval = 4;
          # };
          # right.update = {
          #   command = "hyprswitch";
          #   interval = 4;
          # };
          # up.update = {
          #   command = "hyprctl dispatch hycov:movefocus u";
          #   interval = 4;
          # };
          # down.update = {
          #   command = "hyprctl dispatch hycov:movefocus d";
          #   interval = 4;
          # };
        };
      };
    };
  };
}
