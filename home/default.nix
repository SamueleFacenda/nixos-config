{ config, pkgs, utils, lib, disabledFiles, ... }:
{

  imports = utils.listDirPathsExcluding disabledFiles ./.;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true; # (useless if on nixos)
  
  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "-d";
  };
}
