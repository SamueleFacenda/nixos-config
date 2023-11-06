{
  description = "An full-optional flake template";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-23.05";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 lastModifiedDate;

      overlay = final: prev: {

      };
    in

    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = (nixpkgs.legacyPackages.${system}.extend overlay); in
      {

        packages = {
            myPack = pkgs.stdenv.mkDerivation {
              pname = "myPack";
              src = ./.;
              inherit version;

              nativeBuildInputs = with pkgs; [];

              buildPhase = ''
              '';

              installPhase = ''
                mkdir -p $out/bin
                cp * $out
              '';
            };
          };

        defaultPackage = self.packages.${system}.myPack;

        apps = {
            default = {
              type = "app";
              program = "${self.defaultPackage.${system}}/bin/executable";
            };
          };

        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
            ];

            #shellHook = ''
            #  exec zsh
            #'';

          };

        };
      }
    );
}
