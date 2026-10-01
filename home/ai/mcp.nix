{ pkgs, config, lib, ... }:

let
  # Helper to build an npm package from GitHub
  buildNpmPackage = { pname, version, src, buildInputs ? [], postInstall ? "", npmDepsHash ? null, npmDepsFetcherVersion ? null, makeCacheWritable ? false }:
    pkgs.buildNpmPackage ({
      inherit pname version src buildInputs;
      postInstall = ''
        ${postInstall}
      '';
    } // lib.optionalAttrs (npmDepsHash != null) { inherit npmDepsHash; }
      // lib.optionalAttrs (npmDepsFetcherVersion != null) { inherit npmDepsFetcherVersion; }
      // lib.optionalAttrs (makeCacheWritable != false) { inherit makeCacheWritable; });

# MCP server packages (built inline for reproducibility)
  mcpServers = {
    # Memory server (Node.js) - lemma builds reliably
    lemma = buildNpmPackage {
      pname = "lemma";
      version = "0.21.0";
      src = pkgs.fetchFromGitHub {
        owner = "xenitV1";
        repo = "lemma";
        rev = "v0.21.0";
        hash = "sha256-hMT3PMnUVYUS2blbc75p5mpRWjUk+ohI+sioyR+V52Q=";
      };
      npmDepsHash = "sha256-zeQsjfXXLkgGnzR22Fxquj0d28UTfuEYIsyvr4fxNcw=";
    };

    playwright-mcp = buildNpmPackage {
      pname = "playwright-mcp";
      version = "0.0.82";
      src = pkgs.fetchFromGitHub {
        owner = "microsoft";
        repo = "playwright-mcp";
        rev = "v0.0.82";
        hash = "sha256-O/Z/ufrtcbLInCnlZ1RhW2XsSTKQEn9KMUN+sC+DqdM=";
      };
      npmDepsHash = "sha256-9ezjwWu4tXgO868iDMT9Cst5Ke9ADISvbNbeEOJNmxw=";
    };
  };

in {
  # Enable MCP integration via Home Manager's standard module
  programs.mcp = {
    enable = true;
    servers = {
# Memory server (local) - lemma only (harness-memory disabled due to npm issues)
      lemma = {
        type = "local";
        command = "${mcpServers.lemma}/bin/lemma";
        args = [];
      };

      # GitHub grep search - remote (SSE)
      gh_grep = {
        type = "remote";
        url = "https://mcp.grep.app";
      };

      # Documentation & knowledge - remote (SSE)
      context7 = {
        type = "remote";
        url = "https://mcp.context7.com/mcp";
      };

      deepwiki = {
        type = "remote";
        url = "https://mcp.deepwiki.com/mcp";
      };

      # Browser testing - local
      playwright = {
        type = "local";
        command = "${mcpServers.playwright-mcp}/bin/playwright-mcp";
        args = [];
      };
    };
  };

  # LSP servers configuration (for use in agent configs)
  ai.lsp = {
    rust = {
      command = [ "${lib.getExe pkgs.rust-analyzer}" ];
      extensions = [".rs"];
    };

    python = {
      command = [ "${lib.getExe pkgs.pyright}" "--stdio" ];
      extensions = [".py" ".pyi" ".pyw"];
    };

    typescript = {
      command = [ "${lib.getExe pkgs.typescript-language-server}" "--stdio" ];
      extensions = [".ts" ".tsx" ".js" ".jsx" ".mjs" ".cjs"];
    };

    nix = {
      command = [ "${lib.getExe pkgs.nil}" ];
      extensions = [".nix"];
    };

    go = {
      command = [ "${lib.getExe pkgs.gopls}" ];
      extensions = [".go"];
    };

    cpp = {
      command = [ "${lib.getExe' pkgs.clang-tools "clangd"}" ];
      extensions = [".cpp" ".cc" ".cxx" ".c" ".h" ".hpp"];
    };

    lua = {
      command = [ "${lib.getExe pkgs.lua-language-server}" ];
      extensions = [".lua"];
    };

    markdown = {
      command = [ "${lib.getExe pkgs.marksman}" "server" ];
      extensions = [".md" ".mdx"];
    };

    yaml = {
      command = [ "${lib.getExe pkgs.yaml-language-server}" "--stdio" ];
      extensions = [".yaml" ".yml"];
    };

    json = {
      command = [ "${lib.getExe' pkgs.vscode-langservers-extracted "vscode-json-language-server"}" "--stdio" ];
      extensions = [".json"];
    };

    dockerfile = {
      command = [ "${lib.getExe pkgs.dockerfile-language-server}" "--stdio" ];
      extensions = ["Dockerfile" ".dockerfile"];
    };

    toml = {
      command = [ "${lib.getExe pkgs.taplo}" "lsp" "stdio" ];
      extensions = [".toml"];
    };
  };
}