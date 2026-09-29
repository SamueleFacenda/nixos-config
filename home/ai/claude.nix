{ pkgs, config, lib, secrets, ... }:

{
  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;

    skills = config.ai.skills;
    agents = config.ai.agents;
    commands = config.ai.commands;
    plugins = config.ai.plugins;

    settings = {
      # Use centralized MCP from programs.mcp (via enableMcpIntegration)
      mcpServers = config.programs.mcp.servers;

      # Model configuration - keys from agenix secret files
      env = {
        GITHUB_TOKEN_FILE = secrets.github-token.path;
      };

      # Model aliases
      CLAUDE_MODEL_FAST = "deepseek/deepseek-chat-v3-0324:free";
      CLAUDE_MODEL_SMART = "google/gemini-2.5-flash";
      CLAUDE_MODEL_REASONING = "openai/gpt-5";

      # Memory (uses centralized paths)
      memory = {
        global = { enabled = true; path = "${config.home.homeDirectory}/.config/ai/global-memory.md"; };
        project = { enabled = true; path = ".ai-memory/project-memory.md"; autoLoad = true; };
        shared = { enabled = true; mcpServers = [ "lemma" "honcho" ]; };
      };

      # Use CLAUDE.md as global context (coding standards from coding-rules.md)
      context = config.ai.rules.codingRulesMarkdown;
    };
  };
}