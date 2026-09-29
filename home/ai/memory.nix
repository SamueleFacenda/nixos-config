{ pkgs, config, lib, ... }:

let
  # Shared memory paths
  memoryDir = "${config.home.homeDirectory}/.local/share/ai-memory";
  globalMemoryFile = "${memoryDir}/global-memory.md";
  projectMemoryDir = ".ai-memory";

in {
  # Home manager files for global memory
  home.file = {
    ".config/ai/global-memory.md" = {
      text = "# Global AI Memory\n\nThis file contains global memory shared across all AI agents and projects.\n\n## Key Context\n- System: NixOS with Home Manager\n- AI Agents: opencode, claude-code\n- Memory servers: harness-memory, lemma\n- Model routing: OpenRouter with tiered models\n";
    };
    ".config/ai/coding-rules.md" = {
      text = config.ai.rules.codingRulesMarkdown;
    };
  };

  # Session environment variables (shared by both agents)
  home.sessionVariables = {
    # Shared memory paths
    HARNESS_MEMORY_PATH = "${memoryDir}/harness-memory.db";
    LEMMA_DB_PATH = "${memoryDir}/lemma.db";
    AI_GLOBAL_MEMORY = globalMemoryFile;
    AI_PROJECT_MEMORY_DIR = projectMemoryDir;

    # Headroom proxy
    HEADROOM_PROXY_URL = "http://localhost:8787";
    HEADROOM_OUTPUT_SHAPER = "1";

    # Token optimizer
    TOKEN_OPTIMIZER_ENABLED = "1";

    # Direnv
    DIRENV_ALLOW = "1";
  };
}