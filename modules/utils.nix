{ config, lib, pkgs, ... }:
let
  inherit (builtins) readDir;
  inherit (lib) mapAttrsToList filterAttrs any all mkOption types;
in
rec {

  options.users.default = {
    name = mkOption {
      type = types.str;
      default = "samu";
      example = "john";
      description = "The main user username";
    };
    longName = mkOption {
      type = types.str;
      default = "Samuele Facenda";
      example = "John Doe";
      description = "The main user complete name";
    };
  };

  options.secrets = lib.genAttrs
    [ "spotify" "network-keys" "nix-access-tokens" "wakatime-key" "github-token" ]
    (secret: { enable = lib.mkEnableOption (lib.mdDoc secret); });

  config.lib.utils = rec {

    listDirPathsExcluding = (exclude: path:
      mapAttrsToList
        (n: v: path + "/${n}")
        (filterAttrs
          (n: v: n != "default.nix" && (not_contains n exclude))
          (readDir path)));

    listDirPaths = listDirPathsExcluding [ ];
    contains = (element: list: any (x: x == element) list);
    not_contains = (element: list: all (x: x != element) list);

    getIcon = path: pkgs.adwaita-icon-theme
      + "/share/icons/Adwaita/symbolic/" + path;
    getIconPath = path: "${getIcon path}";
  };
  # config.home-manager.users.samu.lib.utils = config.lib.utils;
}
