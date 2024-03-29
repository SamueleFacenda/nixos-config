# first line for filetype recognition in micro
{
  description = "Samuele's NixOS Flake";

  outputs = { self, nixpkgs, ... }@inputs:
    let
      eachSystem = nixpkgs.lib.genAttrs (import inputs.systems);
      pk = system: nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = builtins.mapAttrs
        (hostname: type: nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs;
          modules = [ (./host + "/${hostname}") ];
        })
        (builtins.readDir ./host);

      devShells = eachSystem (system:
        (import ./shells { pkgs = pk system; }) //
        { default = (pk system).mkShell { inherit (self.checks.${system}.pre-commit-check) shellHook; }; }
      );

      formatter = eachSystem (system: (pk system).nixpkgs-fmt);

      # Warning: these packages are built with a non overwritten nixpkgs. To use, for example,
      # the flake's hyprland in the package build, the package must be overwritten.
      packages = nixpkgs.lib.recursiveUpdate (eachSystem (system: import ./packages (pk system))) {
        # custom images
        x86_64-linux.genericLinux = inputs.nixos-generators.nixosGenerate {
          modules = [
            ./host/genericLinux
            ({ lib, ... }: { networking.networkmanager.enable = lib.mkForce false; })
          ];
          format = "install-iso";
          specialArgs = inputs;
          system = "x86_64-linux";
        };
      };

      templates = import ./templates;

      apps = eachSystem (system: {
        # flake installer, clone himself and do stuff
        default = { type = "app"; program = self.packages.${system}.installer + "/bin/installer"; };
      });

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

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # no cache
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # nixos-hardware.url = "github:SamueleFacenda/nixos-hardware/master"; # My personal fork

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };

    # nixpkgs-wayland = {
    #   url = "github:nix-community/nixpkgs-wayland";
    #   inputs.flake-compat.follows = "flake-compat";
    #   inputs.lib-aggregate.follows = "lib-aggregate";
    #   # inputs.nixpkgs.follows = "nixpkgs";
    # };



    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.flake-compat.follows = "flake-compat";
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
      inputs.flake-compat.follows = "flake-compat";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-compat.url = "github:edolstra/flake-compat";

    lib-aggregate = {
      url = "github:nix-community/lib-aggregate";
      inputs.flake-utils.follows = "flake-utils";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    hyprfocus = {
      url = "github:VortexCoyote/hyprfocus";
      inputs.hyprland.follows = "hyprland";
    };

    hycov = {
      url = "github:DreamMaoMao/hycov";
      inputs.hyprland.follows = "hyprland";
    };

    nur.url = "github:nix-community/NUR";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
