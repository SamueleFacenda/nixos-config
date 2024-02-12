{ config, lib, pkgs, ...}:{
  services.fusuma = {
    enable = true;
    extraPackages = with pkgs; [
      hyprland
      coreutils
    ];
    settings = {
      threshold = {
        swipe = 0.1;
      };
      interval = {
        swipe = 1;
      };
      swipe = {
        "3" = {
          # workspace swipe
          right.command = "hyprctl dispatch prevdesk";
          left.command = "hyprctl dispatch nextdesk";
        };
        "4" = {
          # overview
          begin.command = "hyprctl dispatch hycov:toggleoverview forceallinone ";
          end.command = "hyprctl dispatch hycov:toggleoverview";
          left.update = {
            command = "hyrctl dispatch hycov:movefocus l";
            interval = 5;
          };
          right.update = {
            command = "hyrctl dispatch hycov:movefocus r";
            interval = 5;
          };
          up.update = {
            command = "hyrctl dispatch hycov:movefocus u";
            interval = 5;
          };
          down.update = {
            command = "hyrctl dispatch hycov:movefocus d";
            interval = 5;
          };
        };
      };
    };
  };
}
