{ config, pkgs, utils, ... }: {
  # import all the files/directories in the same directories
  imports = utils.listDirPaths ./.;

  programs.waybar = {
    enable = true;
    systemd.enable = false;
  };
}
