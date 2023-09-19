{ config, pkgs, ... }: {

  imports = [
    ./waybar.nix
    ./sleep.nix
    ./runcpp.nix
  ];
}
