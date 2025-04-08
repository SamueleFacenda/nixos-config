# first line for filetype recognition in micro
{
  description = "Samuele's NixOS Flake";

  outputs = { self, nixpkgs, ... }@inputs:
    let
      eachSystem = nixpkgs.lib.genAttrs (import inputs.systems);
    in
    {
      nixosConfigurations = builtins.mapAttrs
        (hostname: type: nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs;
          modules = [ (./host + "/${hostname}") ];
        })
        (builtins.readDir ./host);

      devShells = eachSystem (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
      });

      formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      packages = nixpkgs.lib.recursiveUpdate (eachSystem (system: import ./packages nixpkgs.legacyPackages.${system})) {
        # custom images
        x86_64-linux.genericLinux = inputs.nixos-generators.nixosGenerate {
          modules = [
            ./host/genericLinux
            ({ lib, ... }: {
              networking.networkmanager.enable = lib.mkForce false;
              users.default.name = lib.mkForce "nixos";
              users.default.longName = lib.mkForce "nixos";
            })
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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # nixos-hardware.url = "github:SamueleFacenda/nixos-hardware/master"; # My personal fork

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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
      inputs.flake-utils.follows = "flake-utils";
      inputs.nur.follows = "nur";
      inputs.git-hooks.follows = "pre-commit-hooks";
    };

    systems.url = "github:nix-systems/default";

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
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

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks-nix.follows = "pre-commit-hooks";
    };
    
    asus-dialpad-driver = {
      url = "github:asus-linux-drivers/asus-dialpad-driver";
      # url = "/home/samu/repos/asus-dialpad-driver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
}
