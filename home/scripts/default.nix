{ config, pkgs, lib, ... }:
let
  inherit (builtins) readDir;
  inherit (lib.attrsets) filterAttrs mapAttrs';
in
{

  home.file = mapAttrs'
    (n: v: {
      name = ".scripts/${n}";
      value = {
        executable = true;
        source = ./. + "/${n}";
      };
    })
    (filterAttrs
      (n: v: n != "default.nix")
      (readDir ./.)
    );

}
