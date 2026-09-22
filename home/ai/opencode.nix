{pkgs, config, lib, ...}: {
  programs.opencode = {
    enable = true;
    package = pkgs.opencode.overrideAttrs { src = pkgs.fetchFromGitHub {
      owner = "anomalyco";
      repo = "opencode";
      tag = "v1.18.32"; 
      hash = "sha256-h5AmK9R0Clk+LT0Tmmfg7iXa6dXNlPi2I5xCjTDRdcg=";
    };};
    enableMcpIntegration = true;
    skills = config.ai.skills;
    agents = config.ai.agents;
    commands = config.ai.commands;
    settings = {
      plugin = [
        "oh-my-opencode-slim@2.2.22"
        "@tarquinen/opencode-dcp@3.2.0"
        "opencode-wakatime@1.3.9"
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
            model = "nvidia/nvidia/nemotron-3-ultra-550b-a55b";
            variant = "extra";
            skills = ["*"];
            mcps = [
              "*"
              "!context7"
            ];
          };

          oracle = {
            model = "nvidia/nvidia/nemotron-3-ultra-550b-a55b";
            variant = "high";
            skills = [
              "refactor-plan"
              "simplify"
            ];
            mcps = [];
          };

          librarian = {
            model = "nvidia/nvidia/nemotron-3-super-120b-a12b";
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
            model = "nvidia/nvidia/nemotron-3-super-120b-a12b";
            variant = "low";
            skills = ["context-map"];
            mcps = [];
          };

          designer = {
            model = "nvidia/nvidia/nemotron-3-ultra-550b-a55b";
            variant = "extra";
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
      };

      # Use the shared OpenCode MCP config for Context7.
      # Disable only oh-my-opencode-slim's built-in registration.
      disabled_mcps = ["context7"];
    };
  };

}
