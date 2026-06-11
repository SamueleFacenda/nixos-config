{pkgs, config, lib, ...}: {
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    settings = {
      plugin = [
        "oh-my-opencode-slim@1.1.2"
        "@tarquinen/opencode-dcp@3.1.12"
        "opencode-wakatime@1.3.8"
      ];
      tools = {
        webfetch = true;
        websearch = true;
      };
      agent = {
        explore.disable = true;
        general.disable = true;
      };
      lsp = {
        markdown = {
          command = [
            "${lib.getExe pkgs.marksman}"
            "server"
          ];
          extensions = [".md" ".mdx"];
        };
      };
      mcp = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
        };
        deepwiki = {
          type = "remote";
          url = "https://mcp.deepwiki.com/mcp";
        };
      };
    };
  };
  home.sessionVariables.OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS = "1";
  xdg.configFile."opencode/oh-my-opencode-slim.json" = {
    force = true;
    text = builtins.toJSON {
      "$schema" = "https://unpkg.com/oh-my-opencode-slim@latest/oh-my-opencode-slim.schema.json";
      autoUpdate = false;
      showStartupToast = false;
      preset = "main";
      presets = {
        main = {
          orchestrator = {
            model = "nvidia/moonshotai/kimi-k2.6";
            skills = ["*"];
            mcps = [
              "*"
              "!context7"
            ];
          };

          oracle = {
            model = "nvidia/mistralai/mistral-large-3-675b-instruct-2512";
            variant = "high";
            skills = [
              "refactor-plan"
              "simplify"
            ];
            mcps = [];
          };

          librarian = {
            model = "nvidia/openai/gpt-oss-120b";
            variant = "low";
            skills = [];
            mcps = [
              "websearch"
              "context7"
              "grep_app"
              "github"
            ];
          };

          explorer = {
            model = "nvidia/openai/gpt-oss-120b";
            variant = "low";
            skills = ["context-map"];
            mcps = [];
          };

          designer = {
            model = "nvidia/qwen/qwen3-coder-480b-a35b-instruct";
            variant = "medium";
            skills = [
              "composition-patterns"
            ];
            mcps = ["playwright"];
          };

          fixer = {
            model = "nvidia/nvidia/nemotron-3-super-120b-a12b";
            variant = "low";
            skills = [
              "refactor"
              "git-commit"
            ];
            mcps = [];
          };
        };
      };
      
      fallback = {
        enabled = true;
        chains = {
          orchestrator = [
            "mistral/magistral-medium-latest"
            "nvidia/qwen/qwen3.5-397b-a17b"
          ];
          librarian = [
            "mistral/codestral-latest"
            "nvidia/nvidia/nemotron-3-super-120b-a12b"
          ];
          explorer = [
            "mistral/codestral-latest"
            "nvidia/nvidia/nemotron-3-super-120b-a12b"
          ];
          fixer = [
            "mistral/codestral-latest"
            "nvidia/openai/gpt-oss-120b"
          ];
          designer = [
            "mistral/mistral-large-latest"
          ];
          oracle = [
            "mistral/mistral-large-latest"
          ];
        };
      };

      # Use the shared OpenCode MCP config for Context7.
      # Disable only oh-my-opencode-slim's built-in registration.
      disabled_mcps = ["context7"];
    };
  };

}
