{ pkgs, lib, ... }:

let
  headroomSrc = pkgs.fetchFromGitHub {
    owner = "headroomlabs-ai";
    repo = "headroom";
    rev = "v0.38.0";
    hash = "sha256-k4xxC+tAiX+pjSj5nK1SBcpbIPQQLKbkQVn5wgzpywY=";
  };

  # GitHub source for token-optimizer (Claude Code adapter with .claude-plugin/)
  tokenOptimizerSrc = pkgs.fetchFromGitHub {
    repo = "token-optimizer";
    owner = "alexgreensh";
    rev = "v5.13.21";
    hash = "sha256-cbagJLiT9mwlZL2KWWc1mykK2hwCEbHwOFVUa463ILg=";
    postFetch = ''
      substituteInPlace "$out/hooks/python-launcher.sh" \
        --replace /opt/homebrew/opt /nix/store
    '';
  };

  ponytailSrc = pkgs.fetchFromGitHub {
    repo = "ponytail";
    owner = "DietrichGebert";
    rev = "v4.8.4";
    hash = "sha256-1A9GkjCuiqwd6Wxl18CZUGYekxrbeTLVDapNUua8ihg=";
  };
in {
  ai.plugins = {
    # Core productivity & safety
    ponytail = ponytailSrc;

    # Full repo for Claude Code
    token-optimizer = tokenOptimizerSrc;

    # Pre-built npm packages for OpenCode (with production dist/ files)
    "token-optimizer-opencode" = pkgs.fetchzip {
      url = "https://registry.npmjs.org/token-optimizer-opencode/-/token-optimizer-opencode-1.2.0.tgz";
      hash = "sha256-LAPdOzmMokSuC7QAzEu8OYKuuv/ZjvUQoQsAmXYcSvU=";
    };

    "opencode-dynamic-context-pruning" = pkgs.fetchzip {
      url = "https://registry.npmjs.org/@tarquinen/opencode-dcp/-/opencode-dcp-3.2.0.tgz";
      hash = "sha256-8eM3F6PVnih+0YZ6DUYdRc1HyzoUtrTqgDw4xH3VD44=";
    };

    "opencode-crawlberg" = pkgs.fetchzip {
      url = "https://registry.npmjs.org/@xberg-io/opencode-crawlberg/-/opencode-crawlberg-1.11.1.tgz";
      hash = "sha256-wJZwl5Qd9lznpbisyZOY0ewE54TzS8YQutbhS3dC8+o=";
    };

    "opencode-chromium" = pkgs.fetchzip {
      url = "https://registry.npmjs.org/opencode-chromium/-/opencode-chromium-1.9.2.tgz";
      hash = "sha256-WHaUm6XCkyfX+jG7MYPWV9xQRPwefkd6b5Y6uAdZmGw=";
    };

    "opencode-wakatime" = pkgs.fetchzip {
      url = "https://registry.npmjs.org/opencode-wakatime/-/opencode-wakatime-1.4.0.tgz";
      hash = "sha256-QF9J6O2KVDZLPSXHB6ZgJw/ktlSKdPWQpfYmj78Gvcw=";
    };

    # Git checkouts that already contain valid entrypoints
    "opencode-toast-history" = pkgs.fetchFromGitHub {
      repo = "opencode-toast-history";
      owner = "LouisLau-art";
      rev = "974e2347bb450bae957f5da3534883b70d2e5428";
      hash = "sha256-Ku/2cnNr5h9yIaCKnNvEubQVOFYsJbeuIItabYRbxtY=";
    };

    # Python CLI package
    headroom = pkgs.python3Packages.buildPythonPackage {
      pname = "headroom-ai";
      version = "0.38.0";
      src = headroomSrc;
      pyproject = true;
      cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
        pname = "headroom-ai";
        version = "0.38.0";
        src = headroomSrc;
        hash = "sha256-ORX8+LTUAgKb0SJLhwh8WLICmtkDR2uvKF9psNjJUhY=";
      };
      nativeBuildInputs = with pkgs.rustPlatform; [
        cargoSetupHook
        maturinBuildHook
      ];
      build-system = [ pkgs.maturin ];
      propagatedBuildInputs = with pkgs.python3Packages; [
        ast-grep-cli
        click
        litellm
        opentelemetry-api
        pydantic
        pyyaml
        rich
        tiktoken
        tomlkit
      ];
      pythonImportsCheck = [ "headroom" ];
    };
  };
}
