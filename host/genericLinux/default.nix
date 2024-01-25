{ config, pkgs, lib, specialArgs, ... }:
# specialArgs are inputs
{
  imports = with specialArgs;
    [
      ../../modules/system.nix
      ../../modules/nixos.nix
      ../../modules/utils.nix

      # speed up kernel builds
      # ../../modules/remote-build.nix

      # choose one or both
      # ../../modules/gnome.nix
      ../../modules/hyprland.nix

      # wifi settings
      ../../modules/network.nix

      # optionals
      ../../timers/empty-trash.nix
      ../../modules/stylix.nix # needed for home-manager

      # secrets
      agenix.nixosModules.default
      ../../secrets

      nur.nixosModules.nur

      { nixpkgs.overlays = [ nixpkgs-wayland.overlay ]; }
      ../../overlays

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;

          extraSpecialArgs = specialArgs // {
            inherit (config.lib) utils;
            inherit (config.age) secrets;
            disabledFiles = [ ];
          };

          users.${config.users.default.name} = {...}:{
            imports = [ ../../home ];
            home = {
              username = config.users.default.name;
              homeDirectory = "/home/" + config.users.default.name;
            };
          };
          backupFileExtension = "bak";
        };
      }
    ];

  # override for custom name
  # users.default.name = "samu";
  # users.default.longName;

  networking.hostName = "nixos-samu";

  # custom options for secrets, fallback placeholder is used
  secrets = {
    # spotify.enable = true;
    # network-keys.enable = true;
    # wakatime-key.enable = true;
    # github-token.enable = true;
    # nix-access-tokens.enable = true;
  };
}
