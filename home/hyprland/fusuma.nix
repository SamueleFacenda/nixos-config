{ config, lib, pkgs, ...}:{
  services.fusuma = {
    enable = true;
    extraPackages = with pkgs; [
      hyprland
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
          right.command = "hyprctl dispatch prevdesk";
          left.command = "hyprctl dispatch nextdesk";
          # enter exit overview (additional commands)
          up.command = "hyprctl dispatch hycov:enteroverview forceallinone";
          down.command = "hyprctl dispatch hycov:leaveoverview";
        };
        "4" = {
          # overview enter and navigation
          begin.command = "hyprctl dispatch hycov:enteroverview forceallinone";
          end.command = "hyprctl dispatch hycov:leaveoverview";
          left.update = {
            command = "hyprctl dispatch hycov:movefocus l";
            interval = 4;
          };
          right.update = {
            command = "hyprctl dispatch hycov:movefocus r";
            interval = 4;
          };
          up.update = {
            command = "hyprctl dispatch hycov:movefocus u";
            interval = 4;
          };
          down.update = {
            command = "hyprctl dispatch hycov:movefocus d";
            interval = 4;
          };
        };
      };
    };
  };
}
