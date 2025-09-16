# nix comments
{
  description = "An rust flake template";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-25.05";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    let
      version = "0.0.1";
      overlay = final: prev: { };
    in

    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = (nixpkgs.legacyPackages.${system}.extend overlay); 
        rust-toolchain = pkgs.symlinkJoin {
          name = "rust-toolchain";
          paths = with pkgs; [ rustc cargo rustPlatform.rustcSrc ];
        };
      in
      {

        packages = rec {
          default = myPack;
          myPack = pkgs.rustPlatform.buildRustPackage {
            pname = "myPack";
            src = pkgs.lib.cleanSource ./.;
            inherit version;

            buildInputs = with pkgs; [ ];

            cargoHash = "";
            verifyCargoDeps = true;
          };
        };
        devShells = {
          default = pkgs.mkShell {
            inputsFrom = [ self.packages.${system}.default ];
            packages = with pkgs; [
              rust-toolchain 
              evcxr 
              rustfmt
              clippy
              (python3.withPackages (ps: with ps; [

              ]))
            ];
            RUST_BACKTRACE = 1;
            RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
          };

        };
      }
    );
}
