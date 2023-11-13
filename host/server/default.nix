{ config, pkgs, lib, specialArgs, ... }:
# specialArgs are inputs
{
  imports = with specialArgs;
    [
      ../../modules/system.nix
      ../../modules/nixos.nix
      ../../modules/remote-build.nix
      # ../../modules/network.nix
      ../../modules/utils.nix
      ../../timers/empty-trash.nix
      ../../secrets

      #./hardware-configuration.nix
      agenix.nixosModules.default

      (args: { nixpkgs.overlays = import ../../overlays args; })

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;

          extraSpecialArgs = specialArgs // {
            inherit (config.lib) utils;
            inherit (config.age) secrets;
            disabledFiles = [
              "hyprland"
              "idea.nix"
              "kitty.nix"
              "dconf.nix"
              "vscode.nix"
              "flameshot.nix"
              "spotify.nix"
            ];
          };
          users.samu = import ../../home;
        };
      }
    ];

  networking.hostName = "server";
}
