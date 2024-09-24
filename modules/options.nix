{ config, options, lib, pkgs, ... }:
let
  inherit (lib) mkOption types genAttrs;
in
{
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

  options.secrets = genAttrs
    [ "spotify" "network-keys" "nix-access-tokens" "wakatime-key" "github-token" ]
    (secret: { enable = lib.mkEnableOption (lib.mdDoc secret); });


  options.home-manager.disabledFiles = mkOption {
    type = types.listOf types.str;
    default = [];
    example = [ "hyprland" ];
    description = "Files that should not imported in home-manager config tree";
  };
}
