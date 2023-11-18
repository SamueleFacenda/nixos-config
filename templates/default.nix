builtins.mapAttrs
  (n: v: {
    path = ./. + "/${n}";
    description = "My personal ${n} template";
  })
  (builtins.removeAttrs
    (builtins.readDir ./.)
    [ "default.nix" ])
