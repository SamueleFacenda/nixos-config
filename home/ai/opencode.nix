{ pkgs, config, lib, ... }:

{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    package = pkgs.opencode.overrideAttrs { src = pkgs.fetchFromGitHub {
      owner = "anomalyco";
      repo = "opencode";
      tag = "v1.18.32";
      hash = "sha256-h5AmK9R0Clk+LT0Tmmfg7iXa6dXNlPi2I5xCjTDRdcg=";
    };};

    # Scratch directory for temporary work (like claude-code's scratch)
    extraPackages = [ pkgs.coreutils ];

    # Use centralized LSP from ai.lsp (MCP comes from programs.mcp via enableMcpIntegration)
    settings.lsp = config.ai.lsp;

    skills = config.ai.skills;
    agents = config.ai.agents;
    commands = config.ai.commands;

    settings = {
      # Use plugins from ai.plugins (all verified with real hashes)
      plugin = [
        config.ai.plugins.ponytail
        config.ai.plugins."token-optimizer"
        config.ai.plugins.headroom
        config.ai.plugins."opencode-dynamic-context-pruning"
        config.ai.plugins."opencode-tokenscope"
        config.ai.plugins."opencode-token-tracker"
        config.ai.plugins."opencode-token-monitor"
        config.ai.plugins."opencode-context-analysis"
        config.ai.plugins."opencode-crawlberg"
        config.ai.plugins."opencode-chromium"
        config.ai.plugins."opencode-websearch-cited"
        config.ai.plugins."opencode-agent-skills"
        config.ai.plugins."oh-my-opencode-slim"
        config.ai.plugins."opencode-wakatime"
        config.ai.plugins."opencode-toast-history"
      ];

      tools = {
        webfetch = true;
        websearch = true;
      };

      # Agent configuration (disable unused agents)
      agent = {
        explore.disable = true;
        general.disable = true;
      };

      # Coding rules from markdown file (opencode uses 'instructions' array of file paths)
      instructions = [
        "${config.home.homeDirectory}/.config/ai/coding-rules.md"
      ];
    };

    # TUI configuration - includes attention/notifications (theme handled by stylix)
    tui = {
      attention = {
        enabled = true;
        notifications = true;
        sound = true;
        volume = 0.4;
      };
    };
  };

  # Session environment variables (model configuration for opencode)
  home.sessionVariables = {
    OPencode_MODEL_FAST = lib.mkForce "deepseek/deepseek-chat-v3-0324:free";
    OPencode_MODEL_SMART = lib.mkForce "google/gemini-2.5-flash";
    OPencode_MODEL_REASONING = lib.mkForce "openai/gpt-5";
    OPENROUTER_BASE_URL = lib.mkForce "https://openrouter.ai/api/v1";
  };

  # oh-my-opencode-slim configuration with agent presets and fallback chains
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
            model = [
              "openrouter/deepseek/deepseek-chat-v3-0324:free"
              "openrouter/google/gemini-2.5-flash"
              "nvidia/nvidia/nemotron-3-ultra-550b-a55b"
            ];
            variant = "extra";
            skills = ["*"];
            mcps = ["*" "!context7"];
          };

          oracle = {
            model = [
              "openrouter/google/gemini-2.5-flash"
              "openrouter/openai/gpt-5"
              "nvidia/nvidia/nemotron-3-ultra-550b-a55b"
            ];
            variant = "high";
            skills = ["*"];
            mcps = [];
          };

          librarian = {
            model = [
              "openrouter/deepseek/deepseek-chat-v3-0324:free"
              "openrouter/google/gemini-2.5-flash"
              "nvidia/nvidia/nemotron-3-super-120b-a12b"
            ];
            variant = "low";
            skills = ["*"];
            mcps = ["websearch" "context7" "deepwiki" "grep_app" "github"];
          };

          explorer = {
            model = [
              "openrouter/deepseek/deepseek-chat-v3-0324:free"
              "nvidia/nvidia/nemotron-3-super-120b-a12b"
            ];
            variant = "low";
            skills = ["*"];
            mcps = [];
          };

          designer = {
            model = [
              "openrouter/openai/gpt-5"
              "nvidia/nvidia/nemotron-3-ultra-550b-a55b"
            ];
            variant = "extra";
            skills = ["*"];
            mcps = ["playwright"];
          };

          fixer = {
            model = [
              "openrouter/google/gemini-2.5-flash"
              "nvidia/nvidia/nemotron-3-super-120b-a12b"
            ];
            variant = "low";
            skills = ["*"];
            mcps = [];
          };
        };
      };
      fallback = { enabled = true; };
      disabled_mcps = ["context7"];
    };
  };
}