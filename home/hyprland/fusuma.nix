{ config, lib, pkgs, ...}:{
  services.fusuma = {
    enable = true;
    extraPackages = with pkgs; [
      hyprland
    ];
    settings = {
      threshold = {
        swipe = 0.7;
      };
      swipe = {
        3 = {
          # workspace swipe
          right.command = "hyprctl dispatch prevdesk";
          left.command = "hyprctl dispatch nextdesk";
        };
      };
    };
  };
}
