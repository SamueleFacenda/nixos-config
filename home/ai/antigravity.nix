{ pkgs, config, lib, ... }:

{
  programs.antigravity-cli = {
    enable = true;
    enableMcpIntegration = true;

    skills = config.ai.skills;
    commands = config.ai.commands;
    context.CONTEXT = config.ai.rules.codingRulesMarkdown;
  };
}
