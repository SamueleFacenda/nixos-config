{ config, pkgs, lib, ... }:
let
  inherit (builtins) readDir;
  inherit (lib.attrsets) filterAttrs mapAttrs';
  inherit (lib.strings) removeSuffix;
in
{

  home.file = mapAttrs'
    (n: v: {
      name = ".local/bin/${removeSuffix ".sh" n}";
      value = {
        executable = true;
        source = ./. + "/${n}";
      };
    })
    (filterAttrs
      (n: v: n != "default.nix")
      (readDir ./.));

}
