{ config, pkgs, lib, utils, disabledFiles, ... }:
let
  lua = lib.generators.mkLuaInline;
in
{
  # import all the files/directories in the same directories
  imports = utils.listDirPathsExcluding disabledFiles ./.;

  wayland.windowManager.hyprland.settings.on = [
    { _args = [ "hyprland.start" (lua "function()\n  hl.exec_cmd([[waybar]])\nend") ]; }
  ];
  programs.waybar = {
    enable = true;
    systemd.enable = false;
  };
  
  # Tray
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
}
