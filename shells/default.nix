{ pkgs, ... }@args:
let
  # function imports and static definitions
  inherit (builtins) traceVal elemAt baseNameOf filter readDir split map listToAttrs toString trace;
  inherit (pkgs.lib.attrsets) filterAttrs nameValuePair mapAttrsToList;

  filename = "default.nix";
  toPath = x: ./. + "/${x}";
in
let
  dirEntries = readDir ./.;
  filesSet = filterAttrs (n: v: v == "regular" && n != filename) dirEntries;
  files = mapAttrsToList (n: v: n) filesSet; # set to list of file names

  getName = x: elemAt (split ".nix" x) 0; # remove final ".nix" from a string
  mkEntry = args: sh: {
    # get name-value couple with shell derivation in value
    name = getName sh;
    value = import (toPath sh) args;
  };
  mkShellsList = files: args: map (mkEntry args) files;
  shells = listToAttrs (mkShellsList files args); # convert list of name-value couples to attrset
in
shells
