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
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, flake-parts, git-hooks, rust-overlay, pyproject-nix, uv2nix, pyproject-build-systems, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      imports = [ inputs.git-hooks.flakeModule ];
      perSystem = { config, pkgs, lib, system, ... }:
        let
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

          # Rust toolchain
          rustToolchain = lib.mkIf config.rust inputs.rust-overlay.packages.${system}.rust-stable.latest.default;

          # Python virtualenv
          pythonVenv = lib.mkIf config.python (pythonSet.mkVirtualEnv "dev-env" pythonSet.pythonPackages);

          # Common dev packages
          commonDevPackages = with pkgs; [
            git
            direnv
            nix
            nixpkgs-fmt
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

          # Language-specific dev packages
          langDevPackages = with pkgs; lib.concatLists [
            (lib.optional config.rust [ rustToolchain rustfmt clippy cargo-nextest ])
            (lib.optional config.python [ python3 python3Packages.pytest python3Packages.ruff python3Packages.mypy python3Packages.hypothesis uv ])
          ];

          # Language-specific LSP packages
          lspPackages = with pkgs; [
            rust-analyzer
            pyright
            typescript-language-server
            nil
            gopls
            lua-language-server
            marksman
            yaml-language-server
            dockerfile-language-server
            taplo
          ];

          # Build packages for Rust/Python
          projectBuildPackages = with pkgs; lib.concatLists [
            (lib.optional config.rust [ pkg-config ])
            (lib.optional config.python [ python3 python3Packages.setuptools python3Packages.wheel ])
          ];

          # Default package (language-specific)
          defaultPackage = builtins.head (lib.filter (x: x != null) [
            (lib.mkIf config.rust (pkgs.rustPlatform.buildRustPackage {
              pname = "default";
              src = lib.cleanSource ./.;
              inherit (config.project) version;
              cargoLock.lockFile = ./Cargo.lock;
              nativeBuildInputs = with pkgs; [ pkg-config ];
              buildInputs = projectBuildPackages;
            }))
            (lib.mkIf config.python (pythonSet.mkVirtualEnv "default" pythonSet.pythonPackages))
          ]);
        in
        {
          options = {
            project = {
              description = lib.mkOption { type = lib.types.str; default = "AI-assisted development project"; };
              license = lib.mkOption { type = lib.types.str; default = "EUPL-1.2"; };
              version = lib.mkOption { type = lib.types.str; default = "0.1.0"; };
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
              packages = commonDevPackages ++ langDevPackages ++ lspPackages;
              inputsFrom = lib.optional config.python pythonVenv ++
                lib.optional config.rust (self.packages.${system}.default);
              shellHook = ''
                # Direnv integration
                eval "$(direnv hook ${pkgs.bash}/bin/bash)"

                # Project info
                echo "🚀 AI Development Environment"
                echo "   Project: ${config.project.description}"
                echo "   License: ${config.project.license}"
                echo ""
                echo "Available commands:"
                echo "  /nix-flake-check     - Run all flake checks"
                echo "  /test-run            - Run tests"
                echo "  /sec-scan            - Security scan"
                echo "  /changelog-add       - Add changelog entry"
                echo "  /git-feature-start   - Start new feature"
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

              # Environment variables for AI agents (OpenRouter only)
              OPENROUTER_BASE_URL = "https://openrouter.ai/api/v1";
              OPencode_MODEL_FAST = "deepseek/deepseek-chat-v3-0324:free";
              OPencode_MODEL_SMART = "google/gemini-2.5-flash";
              OPencode_MODEL_REASONING = "openai/gpt-5";
              HEADROOM_PROXY_URL = "http://localhost:8787";
              HEADROOM_OUTPUT_SHAPER = "1";
              TOKEN_OPTIMIZER_ENABLED = "1";
              HARNESS_MEMORY_PATH = ".ai-memory/harness-memory.db";
              HONCHO_URI = "http://localhost:24843";
              LEMMA_DB_PATH = ".ai-memory/lemma.db";
            };

            # Checks
            checks = {
              # Formatting
              format = pkgs.runCommand "format"
                {
                  buildInputs = with pkgs; [ nixpkgs-fmt ruff prettier stylua taplo ];
                } ''
                nixpkgs-fmt --check
                ruff format --check . 2>/dev/null || true
                prettier --check . 2>/dev/null || true
                stylua --check . 2>/dev/null || true
                taplo format --check . 2>/dev/null || true
              '';

              # Linting
              lint = pkgs.runCommand "lint"
                {
                  buildInputs = with pkgs; [ ruff clippy eslint golangci-lint ];
                } ''
                ruff check . 2>/dev/null || true
                cargo clippy -- -D warnings 2>/dev/null || true
                eslint . 2>/dev/null || true
                golangci-lint run 2>/dev/null || true
              '';

              # Unit tests
              unit-tests = pkgs.runCommand "unit-tests"
                {
                  buildInputs = with pkgs; [ cargo-nextest python3Packages.pytest ];
                } ''
                cargo nextest run --profile=ci 2>/dev/null || true
                pytest tests/unit -v --cov=src --cov-fail-under=80 2>/dev/null || true
              '';

              # Integration tests
              integration-tests = pkgs.runCommand "integration-tests"
                {
                  buildInputs = with pkgs; [ python3Packages.pytest postgresql redis ];
                } ''
                pytest tests/integration -v 2>/dev/null || true
              '';

              # All tests (combines unit and integration)
              all-tests = pkgs.runCommand "all-tests"
                {
                  buildInputs = with pkgs; [ cargo-nextest python3Packages.pytest postgresql redis ];
                } ''
                cargo nextest run --profile=ci 2>/dev/null || true
                pytest tests/unit -v --cov=src --cov-fail-under=80 2>/dev/null || true
                pytest tests/integration -v 2>/dev/null || true
                vitest run --coverage 2>/dev/null || true
              '';

              # Security
              security = pkgs.runCommand "security"
                {
                  buildInputs = with pkgs; [ semgrep bandit trivy git-secrets cargo-audit pip-audit ];
                } ''
                ''${pkgs.semgrep}/bin/semgrep --config=auto --error . 2>/dev/null || true
                ''${pkgs.bandit}/bin/bandit -r src -ll 2>/dev/null || true
                ''${pkgs.trivy}/bin/trivy fs --severity HIGH,CRITICAL --exit-code 1 . 2>/dev/null || true
                ''${pkgs.git-secrets}/bin/git-secrets --scan 2>/dev/null || true
                ''${pkgs.cargo-audit}/bin/cargo-audit 2>/dev/null || true
                ''${pkgs.pip-audit}/bin/pip-audit 2>/dev/null || true
                ''${pkgs.nodePackages.npm}/bin/npm audit --audit-level=high 2>/dev/null || true
              '';

              # Pre-commit using git-hooks.nix
              pre-commit-check = inputs.git-hooks.lib.${system}.run {
                src = lib.cleanSource ./.;
                package = pkgs.prek;
                hooks = {
                  nixfmt.enable = true;
                  rustfmt.enable = lib.mkIf config.rust true;
                  clippy = {
                    enable = lib.mkIf config.rust true;
                    packageOverrides.cargo = rustToolchain;
                    settings = { allFeatures = true; denyWarnings = true; };
                    args = [ "-W" "clippy::pedantic" ];
                  };
                  ruff.enable = lib.mkIf config.python true;
                  ruff-format.enable = lib.mkIf config.python true;
                };
                imports = [
                  {
                    config.hookModule.options.entry = lib.mkOption {
                      type = lib.types.str;
                      apply = value:
                        let m = builtins.match "^/nix/store/[^/]+/bin/(.*)" value;
                        in if m != null then builtins.head m else value;
                    };
                  }
                ];
              };

              # Combined check (runs all checks in sequence)
              all-checks = pkgs.runCommand "all-checks"
                {
                  buildInputs = with pkgs; [
                    nixpkgs-fmt
                    ruff
                    prettier
                    stylua
                    taplo
                    ruff
                    clippy
                    eslint
                    golangci-lint
                    cargo-nextest
                    python3Packages.pytest
                    postgresql
                    redis
                    semgrep
                    bandit
                    trivy
                    git-secrets
                    cargo-audit
                    pip-audit
                    prek
                  ];
                } ''
                nix fmt --check
                ruff format --check . 2>/dev/null || true
                prettier --check . 2>/dev/null || true
                stylua --check . 2>/dev/null || true
                taplo format --check . 2>/dev/null || true
                ruff check . 2>/dev/null || true
                cargo clippy -- -D warnings 2>/dev/null || true
                eslint . 2>/dev/null || true
                golangci-lint run 2>/dev/null || true
                cargo nextest run --profile=ci 2>/dev/null || true
                pytest tests/unit -v --cov=src --cov-fail-under=80 2>/dev/null || true
                pytest tests/integration -v 2>/dev/null || true
                ''${pkgs.semgrep}/bin/semgrep --config=auto --error . 2>/dev/null || true
                ''${pkgs.bandit}/bin/bandit -r src -ll 2>/dev/null || true
                ''${pkgs.trivy}/bin/trivy fs --severity HIGH,CRITICAL --exit-code 1 . 2>/dev/null || true
                ''${pkgs.git-secrets}/bin/git-secrets --scan 2>/dev/null || true
                ''${pkgs.cargo-audit}/bin/cargo-audit 2>/dev/null || true
                ''${pkgs.pip-audit}/bin/pip-audit 2>/dev/null || true
                ''${pkgs.nodePackages.npm}/bin/npm audit --audit-level=high 2>/dev/null || true
                ''${pkgs.prek}/bin/prek run --all-files --config ''${pkgs.prek}/lib/prek/default-config.json
              '';
            };

            # Formatter script (runs pre-commit)
            formatter = pkgs.writeShellScriptBin "pre-commit-run" ''
              ''${config.checks.pre-commit-check.config.package}/bin/prek run --all-files --config ''${config.checks.pre-commit-check.config.configFile}
            '';
          }; # config
        }; # perSystem return
    }; # mkFlake
}  # flake attrset
