{
  description = "An full-optional python flake template";

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
            myPack = pkgs.python3.pkgs.buildPythonApplication {
              pname = "myPack";
              src = ./.;
              inherit version;
              pyproject = true;
              format = "pyproject";

              propagatedBuildInputs = with pkgs.python3.pkgs; [

              ];

              nativeBuildInputs = with pkgs; [
                python3.pkgs.setuptools
              ];

            };
          };

        defaultPackage = self.packages.${system}.myPack;

        apps = {
            default = {
              type = "app";
              program = "${self.defaultPackage.${system}}/bin/my-script";
            };
          };

        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [

              (python3.withPackages (ps: with ps; [

              ]))
            ];

            #shellHook = ''
            #  exec zsh
            #'';

          };

        };
      }
    );
}
