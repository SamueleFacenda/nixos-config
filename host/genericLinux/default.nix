{ config, pkgs, lib, specialArgs, ... }:
# specialArgs are inputs
{
  imports = with specialArgs;
    [
      # mandatory
      ../../modules/system.nix
      ../../modules/nixos.nix
      ../../modules/utils.nix

      #HARDWARE_COMMENT_ANCHOR ./hardware-configuration.nix

      # speed up kernel builds (slow down easy build unless overwritten)
      # ../../modules/remote-build.nix

      # choose one or both
      # ../../modules/gnome.nix
      ../../modules/hyprland.nix

      # optionals wifi settings (networkmanager is already enable by default)
      ../../modules/network.nix

      # optionals
      ../../timers/empty-trash.nix
      ../../modules/stylix.nix # needed for home-manager, not very optional

      # secrets (settings are below)
      agenix.nixosModules.default
      ../../secrets

      # nix user repository
      nur.nixosModules.nur

      # { nixpkgs.overlays = [ nixpkgs-wayland.overlay ]; }
      ../../overlays

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "bak";

          extraSpecialArgs = specialArgs // {
            inherit (config.lib) utils;
            inherit (config.age) secrets;
            disabledFiles = [
              # tex.nix # uncomment for quick test, this is big
              # common.nix # idem
            ];
          };

          users.${config.users.default.name} = _: {
            imports = [ ../../home ];
            home = {
              username = config.users.default.name;
              homeDirectory = "/home/" + config.users.default.name;
              stateVersion = "STATE_VERSION_PLACEHOLDER";
            };
          };
        };
      }
    ];

  # override for custom name (this is also the default value)
  users.default.name = "samu";
  users.default.longName = "Samuele Facenda";

  networking.hostName = "nixos-samu";

  # custom options for secrets, fallback placeholder is used
  secrets = {
    # spotify.enable = true;
    # network-keys.enable = true;
    # wakatime-key.enable = true;
    # github-token.enable = true;
    # nix-access-tokens.enable = true;
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "STATE_VERSION_PLACEHOLDER"; # Did you read the comment?
}
