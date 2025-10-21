# import all nix files in the current folder, and callPackage on them

{ lib
, python3
}:
# execute and import all packages files in the current directory with the given args, using the python callPackage
let
  inherit (lib.attrsets) mapAttrs' filterAttrs attrByPath;
  inherit (builtins) readDir;
  inherit (lib.strings) removeSuffix;
in
mapAttrs'
  (n: v: rec {
    # derivation pname or file/directory name
    name = attrByPath [ "pname" ] (removeSuffix ".nix" n) value;
    value = python3.pkgs.callPackage (import (./. + "/${n}")) { };
  })
  (filterAttrs
    (n: v: n != "default.nix")
    (readDir ./.))
