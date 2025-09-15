# nix comments
{
  description = "An flake template";

  # Nixpkgs / NixOS version to use.
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

            nativeBuildInputs = with pkgs; [ ];

            buildPhase = ''
              '';

            installPhase = ''
              mkdir -p $out/bin
              cp * $out
            '';
          };
        };
        devShells = {
          default = pkgs.mkShell {
            inputsFrom = [ self.packages.${system}.default ];
            packages = with pkgs; [

              (python3.withPackages (ps: with ps; [

              ]))
            ];
          };

        };
      }
    );
}
