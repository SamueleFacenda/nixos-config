{ config, pkgs, utils, disabledFiles, ... }: {
  # import all the files/directories in the same directories
  imports = utils.listDirPathsExcluding disabledFiles ./.;

  programs.waybar = {
    enable = true;
    systemd.enable = false;
  };
}
