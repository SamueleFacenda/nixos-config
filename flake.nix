# first line for filetype recognition in micro
{
  description = "Samuele's NixOS Flake";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # no cache

    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-hardware.url = "github:SamueleFacenda/nixos-hardware/master"; # My personal fork

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    hyprgrass.url = "github:horriblename/hyprgrass"; # it uses the hyprland flake
    # hyprgrass.inputs.hyprland.follows = "hyprland";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    # nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs"; # no cache

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    systems.url = "github:nix-systems/default";

    trashy = {
      url = "github:oberblastmeister/trashy";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      eachSystem = nixpkgs.lib.genAttrs (import inputs.systems);
      pk = system: nixpkgs.legacyPackages."${system}";
    in
    {
      nixosConfigurations = {
        "surface" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs;
          modules = [
            ./host/surface
          ];
        };
      };

      devShells = eachSystem (system:
        (import ./shells { pkgs = pk system; }) //
        { default = (pk system).mkShell { inherit (self.checks.${system}.pre-commit-check) shellHook; }; }
      );

      formatter = eachSystem (system: (pk system).nixpkgs-fmt);

      packages = eachSystem (system: import ./packages (pk system));

      templates = import ./templates;

      checks = eachSystem (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
            shellcheck = {
              enable = true;
              excludes = [ "p10k.zsh" "scope.sh" ];
            };
          };
        };
      });
    };
}
