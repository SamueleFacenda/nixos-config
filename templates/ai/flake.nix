{
  description = "AI-assisted development project template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
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
      flake-utils,
      flake-parts,
      git-hooks,
      rust-overlay,
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
      imports = [ inputs.git-hooks.flakeModule ];
      perSystem =
        {
          config,
          pkgs,
          lib,
          system,
          ...
        }:
        let
          # Rust toolchain
          rustToolchain = lib.mkIf config.rust (
            pkgs.symlinkJoin {
              name = "rust-toolchain";
              paths = with pkgs; [
                rustc
                cargo
                rustPlatform.rustcSrc
              ];
            }
          );

          # Python with uv (computed first as others depend on it)
          pythonSet =
            let
              workspace = inputs.uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };
              overlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };
              editableOverlay = workspace.mkEditablePyprojectOverlay { root = "$REPO_ROOT"; };
              pythonSets = inputs.pyproject-nix.lib.${system}.makePythonPackages {
                python = pkgs.python3;
                overlays = [ overlay ];
              };
            in
            pythonSets.overrideScope editableOverlay;

          pythonVenv = lib.mkIf config.python (pythonSet.mkVirtualEnv "dev-env" pythonSet.pythonPackages);

          # PRE-COMMIT CHECK = SINGLE SOURCE OF TRUTH (git-hooks.nix)
          preCommitCheckBase = git-hooks.lib.${system}.run {
            src = lib.cleanSource ./.;
            package = pkgs.prek;
            hooks = {
              nixfmt = {
                enable = true;
                package = pkgs.nixfmt;
              };
              statix.enable = true;
            };
          };

          # Custom check derivation that includes enabledPackages in build inputs
          preCommitCheck =
            pkgs.runCommand "pre-commit-check"
              {
                buildInputs = [
                  pkgs.prek
                  pkgs.git
                ]
                ++ preCommitCheckBase.enabledPackages;
                PRE_COMMIT_CONFIG_FILE = preCommitCheckBase.config.configFile;
                # Fix permission issues with prek cache
                HOME = "/tmp";
                PRE_COMMIT_HOME = "/tmp/pre-commit-cache";
                # Copy source to have .git directory
                src = lib.cleanSource ./.;
              }
              ''
                mkdir -p $PRE_COMMIT_HOME
                mkdir -p $out
                # Copy source to working directory to have .git
                cp -r $src/* .
                cp -r $src/.git . 2>/dev/null || true
                # Initialize git if not present
                if [ ! -d .git ]; then
                  git init
                  git config user.email "test@test.com"
                  git config user.name "Test"
                  git add .
                  git commit -m "initial" --no-verify
                fi
                ${pkgs.lib.getExe pkgs.prek} run --all-files --config $PRE_COMMIT_CONFIG_FILE
                echo "pre-commit check passed" > $out/result
              '';

          # Formatter DERIVED from pre-commit check - as a derivation with tools in PATH
          formatter =
            pkgs.runCommand "pre-commit-run"
              {
                buildInputs = [ pkgs.prek ] ++ preCommitCheckBase.enabledPackages;
                PRE_COMMIT_CONFIG_FILE = preCommitCheckBase.config.configFile;
              }
              ''
                            mkdir -p $out/bin
                            cat > $out/bin/pre-commit-run <<EOF
                #!/usr/bin/env bash
                mkdir -p /tmp/pre-commit-cache
                HOME=/tmp PRE_COMMIT_HOME=/tmp/pre-commit-cache ${pkgs.lib.getExe pkgs.prek} run --all-files --config $PRE_COMMIT_CONFIG_FILE
                EOF
                            chmod +x $out/bin/pre-commit-run
              '';

          # Language-specific dev packages
          langDevPackages =
            with pkgs;
            lib.concatLists [
              (lib.optional config.rust [
                rustToolchain
                pkgs.rustfmt
                pkgs.clippy
                pkgs.cargo-nextest
              ])
              (lib.optional config.python [
                pythonSet.python3
                pythonSet.pythonPackages.pytest
                pythonSet.pythonPackages.ruff
                pythonSet.pythonPackages.mypy
                pythonSet.pythonPackages.hypothesis
                pkgs.uv
              ])
              (lib.optional config.nodejs [
                pkgs.nodejs
                pkgs.pnpm
              ])
            ];

          # Common dev packages (always available)
          commonDevPackages = with pkgs; [
            git
            direnv
            nix
            nixpkgs-fmt
            nixfmt
            statix
            jq
            yq
            fzf
            ripgrep
            fd
            bat
            delta
            httpie
            curl
            wget
            prettier
            stylua
            taplo
            semgrep
            trivy
            git-secrets
            opencode
          ];

          # Default package (language-specific)
          defaultPackage = builtins.head (
            lib.filter (x: x != null) [
              (lib.mkIf config.rust (
                pkgs.rustPlatform.buildRustPackage {
                  pname = "default";
                  src = lib.cleanSource ./.;
                  inherit (config.project) version;
                  cargoLock.lockFile = ./Cargo.lock;
                  nativeBuildInputs = with pkgs; [ pkg-config ];
                }
              ))
              (lib.mkIf config.python (pythonSet.mkVirtualEnv "default" pythonSet.pythonPackages))
            ]
          );

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
            docker = lib.mkEnableOption "Docker image support";
          };

          config = {
            # Dev shell
            devShells.default = pkgs.mkShell {
              name = "ai-dev";
              packages =
                commonDevPackages ++ langDevPackages ++ preCommitCheckBase.enabledPackages ++ [ formatter ];
              inputsFrom =
                lib.optional config.python pythonVenv ++ lib.optional config.rust self.packages.${system}.default;
              shellHook = preCommitCheckBase.shellHook + ''
                # Direnv integration
                eval "$(direnv hook ${pkgs.bash}/bin/bash)"

                # Project info
                echo "🚀 AI Development Environment"
                echo "   Project: ${config.project.description}"
                echo "   License: ${config.project.license}"
                echo ""
                echo "Available commands:"
                echo "  nix flake check     - Run all flake checks"
                echo "  pre-commit-run      - Run pre-commit hooks"
                echo "  just test           - Run tests"
                echo "  just build          - Build project"
                echo ""

                # Load project memory if exists
                if [ -f .ai-memory/project-memory.md ]; then
                  echo "📋 Project memory loaded"
                fi

                # Python setup
                ${lib.optionalString config.python ''
                  unset PYTHONPATH
                  export UV_NO_SYNC=1
                  export UV_PYTHON=${pythonSet.python.interpreter}
                  export UV_PYTHON_DOWNLOADS=never
                ''}

                # Rust setup
                ${lib.optionalString config.rust ''
                  export RUST_BACKTRACE=1
                  export RUST_SRC_PATH=${pkgs.rustPlatform.rustLibSrc}
                ''}
              '';
            };

            # Formatter
            inherit formatter;

            # Checks - override git-hooks auto pre-commit with our version
            checks = {
              inherit preCommitCheck;
              "pre-commit" = lib.mkForce preCommitCheck;
            };
          };
        };
    };
}
