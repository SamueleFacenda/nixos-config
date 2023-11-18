# import all nix files in the current folder, and callPackage on them
# The return value is a list of all execution results, which is the list of overlays

pkgs:
# execute and import all packages files in the current directory with the given args
let
  inherit (pkgs.lib.attrsets) mapAttrs' filterAttrs;
  inherit (pkgs.lib.strings) splitString;
  inherit (builtins) readDir head;
  inherit (pkgs) callPackage;
in
mapAttrs'
  (n: v: rec {
    name = value.pname; # rec value.pname alternative
    value = callPackage (import (./. + "/${n}")) { };
  })
  (filterAttrs
    (n: v: n != "default.nix")
    (readDir ./.))
