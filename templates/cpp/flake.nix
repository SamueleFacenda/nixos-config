# nix comment
{
  description = "An Hello World in C++";

  inputs.nixpkgs.url = "nixpkgs/nixos-25.05";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    let
      version = "0.0.1";
      overlay = final: prev: { };
    in

    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = (nixpkgs.legacyPackages.${system}.extend overlay); in
      {

        packages = rec {
          default = myPack;
          myPack = pkgs.stdenv.mkDerivation {
            pname = "myPack";
            src = ./.;
            inherit version;

            nativeBuildInputs = with pkgs; [
              cmake
            ];
          };
        };

        devShells = {
          default = pkgs.mkShell {
            inputsFrom = [ self.packages.${system}.default ];
            nativeBuildInputs = with pkgs; [
            ];
          };
        };
      });
}
