{ pkgs, config, lib, ... }:

{
  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;

    skills = config.ai.skills;
    agents = config.ai.agents;
    commands = config.ai.commands;

    # Plugins managed via Home Manager's plugins option
    # (ponytail excluded: the wrapper's per-file symlinks trip Claude Code's
    # path-escape security check, so it is symlinked directly below)
    plugins = lib.filterAttrs (name: _:
      builtins.elem name [ "token-optimizer" "opencode-chromium" ]
    ) config.ai.plugins;

    context = config.ai.rules.codingRulesMarkdown;
  };

  # Direct symlink for ponytail to avoid Home Manager's path-escape bug
  home.file."${config.programs.claude-code.configDir}/skills/ponytail".source =
    config.ai.plugins.ponytail;
}
