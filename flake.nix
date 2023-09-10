{
  description = "Samuele's NixOS Flake";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    spicetify-nix.url = github:the-argus/spicetify-nix;
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    hyprgrass.url = "github:horriblename/hyprgrass"; # it uses the hyprland flake
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      "surface" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;
        modules = with inputs; [
          ./host/surface

          agenix.nixosModules.default
          nixos-hardware.nixosModules.microsoft-surface-pro-intel

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = inputs;
            home-manager.users.samu = import ./home;
          }
        ];
      };
    };

    devShells."${system}" = import ./shells {
      pkgs = nixpkgs.legacyPackages.${system};
    };
  };
}
