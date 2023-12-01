# nix comments
{
  description = "An full-optional flake template";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-23.05";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  inputs.pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, flake-utils, pre-commit-hooks }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 lastModifiedDate;

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

        apps = {
          default = {
            type = "app";
            program = "${self.defaultPackage.${system}}/bin/executable";
          };
        };

        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [

              (python3.withPackages (ps: with ps; [

              ]))
            ];

            inherit (self.checks.${system}.pre-commit-check) shellHook;

          };

        };

        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
              shellcheck.enable = true;
            };
          };
        };
      }
    );
}
