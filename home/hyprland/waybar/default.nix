{ config, pkgs, utils, disabledFiles, ... }: {
  # import all the files/directories in the same directories
  imports = utils.listDirPathsExcluding disabledFiles ./.;

  wayland.windowManager.hyprland.settings.exec-once = [ "waybar" ];
  programs.waybar = {
    enable = true;
    systemd.enable = false;
  };
}
