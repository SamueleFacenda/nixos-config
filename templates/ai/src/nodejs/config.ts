// config.ts
// Configuration management for Node.js

import { z } from 'zod';
import * as fs from 'fs/promises';
import * as path from 'path';
import * as toml from 'toml';

// Configuration schema
const OpenRouterConfigSchema = z.object({
  api_key: z.string().optional().default(''),
  base_url: z.string().url().default('https://openrouter.ai/api/v1'),
  model_fast: z.string().default('deepseek/deepseek-chat-v3-0324:free'),
  model_smart: z.string().default('google/gemini-2.5-flash'),
  model_reasoning: z.string().default('openai/gpt-5'),
});

const TokenOptimizerConfigSchema = z.object({
  enabled: z.boolean().default(true),
  headroom_proxy_url: z.string().url().default('http://localhost:8787'),
  headroom_output_shaper: z.boolean().default(true),
});

const MemoryConfigSchema = z.object({
  global_path: z.string().default('~/.config/ai-memory'),
  project_path: z.string().default('.ai-memory'),
});

const ConfigSchema = z.object({
  openrouter: OpenRouterConfigSchema,
  token_optimizer: TokenOptimizerConfigSchema,
  memory: MemoryConfigSchema,
  debug: z.boolean().default(false),
});

export type Config = z.infer<typeof ConfigSchema>;
export type OpenRouterConfig = z.infer<typeof OpenRouterConfigSchema>;

export class ConfigManager {
  private config: Config;

  constructor(config: Config) {
    this.config = config;
  }

  static async load(configPath: string): Promise<ConfigManager> {
    try {
      const fileContent = await fs.readFile(configPath, 'utf-8');
      const parsed = toml.parse(fileContent);
      const config = ConfigSchema.parse(parsed);
      return new ConfigManager(config);
    } catch (error) {
      // Return default config if file doesn't exist or is invalid
      return new ConfigManager(ConfigSchema.parse({}));
    }
  }

  get openrouter(): OpenRouterConfig {
    return this.config.openrouter;
  }

  get tokenOptimizer() {
    return this.config.token_optimizer;
  }

  get memory() {
    return this.config.memory;
  }

  get debug(): boolean {
    return this.config.debug;
  }
}

// For backward compatibility
export const Config = ConfigManager;