{ pkgs, config, lib, ... }:

{
  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;

    skills = config.ai.skills;
    agents = config.ai.agents;
    commands = config.ai.commands;

    # Claude-compatible plugins only (opencode-runtime JS plugins are excluded)
    plugins = lib.filterAttrs (name: _:
      builtins.elem name [ "ponytail" "token-optimizer" "opencode-chromium" ]
    ) config.ai.plugins;

    # Global context written to ~/.claude/CLAUDE.md (top-level option, not a settings key)
    context = config.ai.rules.codingRulesMarkdown;
  };
}
