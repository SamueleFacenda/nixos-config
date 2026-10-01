{ pkgs, config, lib, ... }:
{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    package = pkgs.opencode.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "anomalyco";
        repo = "opencode";
        tag = "v1.18.32";
        hash = "sha256-h5AmK9R0Clk+LT0Tmmfg7iXa6dXNlPi2I5xCjTDRdcg=";
      };
    };

    # Scratch directory for temporary work (like claude-code's scratch)
    extraPackages = [ config.ai.plugins.headroom pkgs.coreutils ];

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
        config.ai.plugins."opencode-crawlberg"
        config.ai.plugins."opencode-chromium"
        config.ai.plugins."opencode-websearch-cited"
        config.ai.plugins."opencode-wakatime"
        config.ai.plugins."opencode-toast-history"
      ];

      tools = {
        webfetch = true;
        websearch = true;
      };

      # Provider configuration with cost-optimized models
      provider = {
        openrouter = {
          options = {
            websearch_cited = { model = "google/gemini-2.5-flash"; };
          };
        };
        nvidia = {
          options = {
            model = "z-ai/glm-5.1";
          };
        };
      };

      # Per-agent model configuration with fallbacks (first available wins)
      agent = {
        # Primary agents - same model chain for build & plan
        build = {
          model = "nvidia/nvidia/nemotron-3-ultra-550b-a55b"; # [
          # "openrouter/google/gemini-2.5-flash"
          # "openrouter/openai/gpt-5"
          # "nvidia/nvidia/nemotron-3-ultra-550b-a55b"
          # ];
          # Allow all subagents; explore/scout are preferred for read-only tasks
          permission = {
            task = {
              "*" = "allow";
            };
          };
        };
        plan = {
          model = "nvidia/nvidia/nemotron-3-ultra-550b-a55b"; # [
          # "openrouter/google/gemini-2.5-flash"
          # "openrouter/openai/gpt-5"
          # "nvidia/nvidia/nemotron-3-ultra-550b-a55b"
          # ];
          # Allow subagents for analysis/planning tasks
          permission = {
            task = {
              "*" = "allow";
            };
          };
        };
        compaction = {
          model = "nvidia/nvidia/nemotron-3-ultra-550b-a55b";
        };
        title = {
          model = "nvidia/nvidia/nemotron-3-ultra-550b-a55b";
        };
        summary = {
          model = "nvidia/nvidia/nemotron-3-ultra-550b-a55b";
        };

        # Subagents - enable them and configure models
        general = {
          model = "nvidia/nvidia/nemotron-3-ultra-550b-a55b"; # [
          # "openrouter/google/gemini-2.5-flash"
          # "openrouter/openai/gpt-5"
          # "nvidia/nvidia/nemotron-3-ultra-550b-a55b"
          # ];
        };
        explore = {
          model = "nvidia/nvidia/nemotron-3-super-120b-a12b"; # [
          # "openrouter/deepseek/deepseek-chat-v3-0324:free"
          # "nvidia/nvidia/nemotron-3-super-120b-a12b"
          # ];
          # Read-only: prevent sub-subagents
          permission = {
            task = {
              "*" = "deny";
            };
          };
        };
        scout = {
          model = "nvidia/nvidia/nemotron-3-super-120b-a12b"; # [
          # "openrouter/deepseek/deepseek-chat-v3-0324:free"
          # "nvidia/nvidia/nemotron-3-super-120b-a12b"
          # ];
          # Read-only: prevent sub-subagents
          permission = {
            task = {
              "*" = "deny";
            };
          };
        };
      };

      # Explicitly allow /tmp/opencode/* (pre-approved by default, but explicit for clarity)
      permission.external_directory = {
        "/tmp/opencode/**" = "allow";
        "/tmp/opencode-*/**" = "allow";  # covers per-session variant if TMPDIR customized
      };

      # Coding rules from markdown file (opencode uses 'instructions' array of file paths)
      instructions = [
        "${config.home.homeDirectory}/.config/ai/coding-rules.md"
        "STRICTLY follow the coding rules in the above file. No exceptions. Enforce on every task."
        "Before starting any task, consult <available_skills> and load matching skills via the `skill` tool."
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

  # Session environment variables (model configuration for opencode - fallback for agents without explicit config)
  home.sessionVariables = {
    OPencode_MODEL_FAST = lib.mkForce "deepseek/deepseek-chat-v3-0324:free";
    OPencode_MODEL_SMART = lib.mkForce "google/gemini-2.5-flash";
    OPencode_MODEL_REASONING = lib.mkForce "openai/gpt-5";
    OPENROUTER_BASE_URL = lib.mkForce "https://openrouter.ai/api/v1";
  };
}
