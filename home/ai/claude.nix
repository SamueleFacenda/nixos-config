{ pkgs, config, ... } : {
  programs.claude-code = {
    enable = true;
    skills = config.ai.skills;
    agents = config.ai.agents;
    commands = config.ai.commands;
    enableMcpIntegration = true;
  };
}
