{
  description = "An over-engineered Hello World in C";

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

        packages = {
          myPack = pkgs.stdenv.mkDerivation {
            pname = "myPack";
            src = ./.;
            inherit version;

            nativeBuildInputs = with pkgs; [
              gcc
            ];

            buildPhase = ''
              g++ main.cpp
            '';

            installPhase = ''
              mkdir -p $out/bin
              find . -type f ! -iregex ".*\.\(c\|cpp\|cc\|nix\|lock\|envrc\|txt\)$" \
                -exec mv -t "''${out}/bin" "{}" +
            '';
          };
        };

        defaultPackage = self.packages.${system}.myPack;

        apps = {
          default = {
            type = "app";
            program = "${self.defaultPackage.${system}}/bin/a.out";
          };
        };

        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              gcc
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
              clang-format = {
                enable = true;
                types_or = [ "c" "c++" ];
              };
              clang-tidy.enable = true;
            };
          };
        };

      });
}
