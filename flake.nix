{
  description = "Samuele's NixOS Flake";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-hardware.url = "github:SamueleFacenda/nixos-hardware/master"; # My personal fork

    spicetify-nix.url = "github:the-argus/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    hyprgrass.url = "github:horriblename/hyprgrass"; # it uses the hyprland flake
    #hyprgrass.inputs.hyprland.follows = "nixpkgs";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    # nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    systems.url = "github:nix-systems/default";
  };

  outputs = { nixpkgs, ... }@inputs:
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

      devShells = eachSystem (system: import ./shells { pkgs = pk system; });

      formatter = eachSystem  (system: (pk system).nixpkgs-fmt);

      # use updated wayland packages
      nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];

      packages = eachSystem (system: import ./packages (pk system));
    };
}
