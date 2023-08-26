{pkgs, ...}@args :
  let
    inherit (builtins) traceVal elemAt baseNameOf filter readDir split map listToAttrs toString trace;
    inherit (pkgs.lib.attrsets) filterAttrs nameValuePair mapAttrsToList;
    filename = "make-shell.nix";
    toPath = x: ./. + "/${x}";
  in
  let 
    dirEntries = readDir ./. ;
    filesSet = filterAttrs (n: v: v == "regular" && n != filename) dirEntries;
    files = mapAttrsToList (n: v: n) filesSet;
    
    getName = x: elemAt (split ".nix" x) 0;
    mkEntry = args: sh: nameValuePair (getName sh) (import (toPath sh) args);
    mkShellsList = files: args: map (mkEntry args) files;
  in
    listToAttrs (mkShellsList files args)
