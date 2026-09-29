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
}