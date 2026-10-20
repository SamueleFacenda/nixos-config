{
  description = "AI-assisted development project template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pyproject-nix.follows = "pyproject-nix";
        uv2nix.follows = "uv2nix";
      };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      git-hooks,
      pyproject-nix,
      uv2nix,
      pyproject-build-systems,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      imports = [ git-hooks.flakeModule ];

      perSystem =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        let
          workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };
          overlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };
          pythonSet =
            (pkgs.callPackage pyproject-nix.build.packages { python = pkgs.python3; }).overrideScope
              (
                lib.composeManyExtensions [
                  pyproject-build-systems.overlays.wheel
                  overlay
                ]
              );
          pythonDevVenv = pythonSet.mkVirtualEnv "ai-project-dev" workspace.deps.all;

          pythonPackage = pythonSet.mkVirtualEnv "ai-project-env" workspace.deps.default;

          rustPackage = pkgs.rustPlatform.buildRustPackage {
            pname = "ai-project";
            inherit (config.project) version;
            src = lib.cleanSource ./.;
            cargoLock.lockFile = ./Cargo.lock;
            nativeBuildInputs = [ pkgs.pkg-config ];
          };

          nodejsPackage = pkgs.buildNpmPackage {
            pname = "ai-project";
            inherit (config.project) version;
            src = lib.cleanSource ./.;
            npmDeps = pkgs.importNpmLock { npmRoot = ./.; };
            npmConfigHook = pkgs.importNpmLock.npmConfigHook;
            installPhase = ''
              cp -r dist $out
            '';
          };

          dockerImage = pkgs.dockerTools.buildLayeredImage {
            name = "ai-project";
            tag = "latest";
            contents = [ defaultPackageForOutput ];
          };

          defaultPackageForOutput =
            if config.rust then
              rustPackage
            else if config.python then
              pythonPackage
            else if config.nodejs then
              nodejsPackage
            else
              pkgs.runCommand "ai-project" { } "echo 'No language enabled' > $out/README.txt";

          formatter =
            pkgs.runCommand "pre-commit-run"
              {
                buildInputs = [ pkgs.prek ] ++ config.pre-commit.settings.enabledPackages;
              }
              ''
                mkdir -p $out/bin
                echo '#!/usr/bin/env bash' > $out/bin/pre-commit-run
                echo 'mkdir -p /tmp/pre-commit-cache' >> $out/bin/pre-commit-run
                echo 'HOME=/tmp PRE_COMMIT_HOME=/tmp/pre-commit-cache ${pkgs.lib.getExe pkgs.prek} run --all-files --config ${config.pre-commit.settings.configFile}' >> $out/bin/pre-commit-run
                chmod +x $out/bin/pre-commit-run
              '';

          langDevPackages =
            lib.optionals config.rust (
              with pkgs;
              [
                rustc
                cargo
                rustfmt
                clippy
                cargo-nextest
                cargo-audit
                rust-analyzer
              ]
            )
            ++ lib.optionals config.python [
              pythonDevVenv
              pkgs.uv
            ]
            ++ lib.optionals config.nodejs [ pkgs.nodejs ];

          commonDevPackages = with pkgs; [
            git
            just
            direnv
            nix
            nixfmt
            statix
            jq
            fzf
            ripgrep
            fd
            curl
            prettier
            taplo
            semgrep
            trivy
            git-secrets
            prek
            opencode
          ];
        in
        {
          options = {
            project = {
              description = lib.mkOption {
                type = lib.types.str;
                default = "AI-assisted development project";
              };
              license = lib.mkOption {
                type = lib.types.str;
                default = "EUPL-1.2";
              };
              version = lib.mkOption {
                type = lib.types.str;
                default = "0.1.0";
              };
            };
            rust = lib.mkEnableOption "Rust support";
            python = lib.mkEnableOption "Python support";
            nodejs = lib.mkEnableOption "Node.js support";
            docker = lib.mkEnableOption "Docker image output (dockerImage package)";
          };

          config = {
            pre-commit.settings = {
              package = pkgs.prek;
              hooks = {
                nixfmt.enable = true;
                statix.enable = true;
              };
            };

            devShells.default = pkgs.mkShell {
              name = "ai-dev";
              packages =
                commonDevPackages ++ langDevPackages ++ config.pre-commit.settings.enabledPackages ++ [ formatter ];
              inputsFrom = lib.optional (config.rust || config.python || config.nodejs) defaultPackageForOutput;
              shellHook = config.pre-commit.shellHook + ''
                echo "🚀 AI Development Environment"
                echo "   Project: ${config.project.description}"
                echo "   License: ${config.project.license}"
                echo ""
                echo "Available commands:"
                echo "  nix flake check   - Run all flake checks"
                echo "  pre-commit-run    - Run pre-commit hooks"
                echo "  just test         - Run tests"
                echo "  just build        - Build project"
                echo "  just security     - Security scan"
                echo ""
                ${lib.optionalString config.python ''
                  unset PYTHONPATH
                  export UV_NO_SYNC=1
                  export UV_PYTHON=${pythonSet.python.interpreter}
                  export UV_PYTHON_DOWNLOADS=never
                ''}
                ${lib.optionalString config.rust ''
                  export RUST_BACKTRACE=1
                  export RUST_SRC_PATH=${pkgs.rustPlatform.rustLibSrc}
                ''}
              '';
            };

            inherit formatter;

            packages = {
              default = defaultPackageForOutput;
            }
            // lib.optionalAttrs config.docker { inherit dockerImage; }
            // lib.optionalAttrs config.rust { rust = rustPackage; }
            // lib.optionalAttrs config.python { python = pythonPackage; }
            // lib.optionalAttrs config.nodejs { nodejs = nodejsPackage; };
          };
        };
    };
}
