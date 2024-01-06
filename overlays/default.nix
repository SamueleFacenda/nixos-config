{ config, lib, pkgs, specialArgs, ... }: {

  nixpkgs.overlays =
    builtins.map import (config.lib.utils.listDirPathsExcluding [ "new-packages.nix" "README.md" ] ./.) ++
    [(import ./new-packages.nix specialArgs)];
}
