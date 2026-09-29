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
      text = "# Global AI Memory\n\nThis file contains global memory shared across all AI agents and projects.\n\n## Key Context\n- System: NixOS with Home Manager\n- AI Agents: opencode, claude-code\n- Memory servers: honcho, harness-memory, lemma\n- Model routing: OpenRouter with tiered models\n";
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
    HONCHO_URI = "http://localhost:24843";
    AI_GLOBAL_MEMORY = globalMemoryFile;
    AI_PROJECT_MEMORY_DIR = projectMemoryDir;

    # Headroom proxy
    HEADROOM_PROXY_URL = "http://localhost:8787";
    HEADROOM_OUTPUT_SHAPER = "1";

    # Token optimizer
    TOKEN_OPTIMIZER_ENABLED = "1";

    # Direnv
    DIRENV_ALLOW = "1";

    # Model aliases (keys sourced from sops, not in config)
    OPencode_MODEL_FAST = "deepseek/deepseek-flash-latest";
    OPencode_MODEL_SMART = "xiaomi/mimo-v2.6-pro";
    OPencode_MODEL_REASONING = "openai/gpt-astra-latest";

    # MCP paths
    OPENROUTER_BASE_URL = "https://openrouter.ai/api/v1";
  };
}