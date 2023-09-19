{ pkgs, ... }@args:
let
  inherit (builtins) head readDir;
  inherit (pkgs.lib.strings) splitString;
  inherit (pkgs.lib.attrsets) filterAttrs mapAttrs';
in

# import all the file/folders in this directory
# and call them with all the arguments of a module
# (create an attrsets of shells)
mapAttrs'
  (n: v: {
    name = head (splitString "." n);
    value = import (./. + "/${n}") args; })
  (filterAttrs
    (n: v: n != "default.nix")
    (readDir ./.))
