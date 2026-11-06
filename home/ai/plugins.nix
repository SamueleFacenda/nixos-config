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
    rev = "v5.3.2";
    hash = "sha256-IJlhfkdXI6pMZZCZO7XBRg88LBiNfzc5Gnm4ofGybL8=";
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

    # the bundled ai-rulez MCP server fails opencode 2's tools/list
    # validation (array outputSchema); the plugin's direct tools cover
    # scrape/crawl/map, so drop the implicit server
    "opencode-crawlberg" = let
      src = pkgs.fetchzip {
        url = "https://registry.npmjs.org/@xberg-io/opencode-crawlberg/-/opencode-crawlberg-1.12.0.tgz";
        hash = "sha256-8qsxMaTNfKmeM7uJxSDcyXihbkc3oKBMUfORvymRDVE=";
      };
    in
      pkgs.runCommand "opencode-crawlberg" { nativeBuildInputs = [ pkgs.jq ]; } ''
        cp -r ${src}/. $out
        chmod -R u+w $out
        jq 'del(.mcp)' $out/.opencode/ai-rulez-bundle.json > $out/.opencode/b.tmp
        mv $out/.opencode/b.tmp $out/.opencode/ai-rulez-bundle.json
      '';

    # Prebuilt Rust CLI the crawlberg plugin spawns from PATH (x86_64-linux only)
    crawlberg = pkgs.stdenv.mkDerivation rec {
      pname = "crawlberg";
      version = "1.12.0";
      src = pkgs.fetchzip {
        url = "https://github.com/xberg-io/crawlberg/releases/download/v${version}/crawlberg-cli-x86_64-unknown-linux-gnu.tar.gz";
        hash = "sha256-5Lt6s292jy37lMio9BrJYLy7Z7DL1/yx3ejeTVPhcho=";
      };
      nativeBuildInputs = [ pkgs.autoPatchelfHook ];
      buildInputs = [ pkgs.libgcc ];
      installPhase = ''
        mkdir -p $out/bin
        install -m755 crawlberg $out/bin/crawlberg
      '';
      meta.platforms = [ "x86_64-linux" ];
    };

    "opencode-chromium" = pkgs.fetchzip {
      url = "https://registry.npmjs.org/opencode-chromium/-/opencode-chromium-1.9.3.tgz";
      hash = "sha256-84oE9pUPT/Fqs4ltHtJmEceChk0eXB7yuqXE8EAhups=";
    };

    "opencode-wakatime" = pkgs.fetchzip {
      url = "https://registry.npmjs.org/opencode-wakatime/-/opencode-wakatime-1.4.0.tgz";
      hash = "sha256-QF9J6O2KVDZLPSXHB6ZgJw/ktlSKdPWQpfYmj78Gvcw=";
    };

    # native OpenCode plugin (dual v1/v2 export, self-contained bundle);
    # talks to the headroom-proxy systemd user service on 127.0.0.1:8787
    "headroom-opencode" = pkgs.fetchzip {
      url = "https://registry.npmjs.org/headroom-opencode/-/headroom-opencode-0.42.0.tgz";
      hash = "sha256-CPxsxAqjkk6hzK+ZCg+wHKzEVXkFUlA+dhJjvwZdPXE=";
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
        # [proxy] extra: the headroom-proxy service refuses to start without
        # these (see headroom/cli/proxy.py required_modules)
        fastapi
        uvicorn
        httpx
        openai
        mcp
        magika
        zstandard
        websockets
        onnxruntime
        transformers
        orjson
        httpx
        h2
        torch
        pillow
      ];
      pythonImportsCheck = [ "headroom" ];
    };
  };
}
