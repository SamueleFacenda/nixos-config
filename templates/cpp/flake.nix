{
  description = "An over-engineered Hello World in C";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-23.05";

  outputs = { self, nixpkgs }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 lastModifiedDate;

      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlay ]; });

    in

    {
      overlay = final: prev: {};

      packages = forAllSystems (system: {
          myPack = nixpkgsFor.${system}.stdenv.mkDerivation {
            pname = "myPack";
            src = ./.;
            inherit version;

            nativeBuildInputs = with nixpkgsFor.${system}; [
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
        });

      defaultPackage = forAllSystems (system: self.packages.${system}.myPack);

      apps = forAllSystems (system: {
          default = {
            type = "app";
            program = "${self.defaultPackage.${system}}/bin/a.out";
          };
        });

      devShells = forAllSystems (system: {

        default = nixpkgsFor.${system}.mkShell {
          nativeBuildInputs = with nixpkgsFor.${system}; [
            gcc
          ];
          #shellHook = ''
          #  exec zsh
          #'';
        };

      });

    };
}
