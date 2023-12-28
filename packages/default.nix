# import all nix files in the current folder, and callPackage on them
# The return value is a list of all execution results, which is the list of overlays

pkgs:
# execute and import all packages files in the current directory with the given args
let
  inherit (pkgs.lib.attrsets) mapAttrs' filterAttrs attrByPath;
  inherit (builtins) readDir head;
  inherit (pkgs) callPackage;
  inherit (pkgs.lib.strings) splitString;
in
mapAttrs'
  (n: v: rec {
    # derivation pname or file/directory name
    name = attrByPath ["pname"] (head (splitString ".nix" n)) value;
    value = callPackage (import (./. + "/${n}")) { };
  })
  (filterAttrs
    (n: v: n != "default.nix")
    (readDir ./.))
