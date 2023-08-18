{
  description = "Samuele's NixOS Flake";

  inputs = {

    # Official NixOS package source, using nixos-unstable branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
    
    spicetify-nix.url = github:the-argus/spicetify-nix;
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
	experimental-features = [ "nix-command" "flakes" ];
	substituters = [
	  "https://cache.nixos.org/"
	];

	# nix community`s cache server
	extra-substituters = [
	  "https://nix-community.cachix.org"
	];
	extra-trusted-public-keys = [
	  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
	];
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      "surface" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs // {inputs = inputs;};
        modules = with inputs; [
          ./host/surface
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

    devShells."${system}".pwn = import ./shells/pwn/default.nix {
    	pkgs = nixpkgs.legacyPackages.${system};
    };
  };
}
