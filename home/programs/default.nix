{ config, pkgs, lib, ...}: {
  # import all the files/directories in the same directories
  imports = builtins.filter
      (x: x != ./default.nix)
      (lib.mapAttrsToList
        (n: v: ./. + "/${n}")
        (builtins.readDir ./.));
}
