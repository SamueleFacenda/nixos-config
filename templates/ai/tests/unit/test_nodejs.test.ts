// Unit tests for Node.js/TypeScript code
// Run with: pnpm test

import { describe, it, expect, vi, beforeEach } from 'vitest';
import { ConfigManager, Config } from '../src/nodejs/config.js';
import { AIClient } from '../src/nodejs/ai.js';

// Mock file system
vi.mock('fs/promises', () => ({
  readFile: vi.fn(),
}));

// Mock toml
vi.mock('toml', () => ({
  parse: vi.fn(),
}));

import * as fs from 'fs/promises';
import * as toml from 'toml';

describe('ConfigManager', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('should return default config when file does not exist', async () => {
    (fs.readFile as any).mockRejectedValue(new Error('ENOENT'));
    
    const config = await ConfigManager.load('nonexistent.toml');
    
    expect(config.openrouter.base_url).toBe('https://openrouter.ai/api/v1');
    expect(config.openrouter.model_fast).toBe('deepseek/deepseek-chat-v3-0324:free');
    expect(config.openrouter.model_smart).toBe('google/gemini-2.5-flash');
    expect(config.openrouter.model_reasoning).toBe('openai/gpt-5');
    expect(config.tokenOptimizer.enabled).toBe(true);
    expect(config.tokenOptimizer.headroom_proxy_url).toBe('http://localhost:8787');
    expect(config.tokenOptimizer.headroom_output_shaper).toBe(true);
    expect(config.debug).toBe(false);
  });

  it('should parse valid TOML config', async () => {
    const mockConfig = {
      openrouter: {
        api_key: 'test-key',
        base_url: 'https://custom.api/v1',
        model_fast: 'custom/fast',
        model_smart: 'custom/smart',
        model_reasoning: 'custom/reasoning',
      },
      token_optimizer: {
        enabled: false,
        headroom_proxy_url: 'http://localhost:9999',
        headroom_output_shaper: false,
      },
      memory: {
        global_path: '~/.custom-memory',
        project_path: '.custom-memory',
      },
      debug: true,
    };

    (fs.readFile as any).mockResolvedValue('mock toml content');
    (toml.parse as any).mockReturnValue(mockConfig);

    const config = await ConfigManager.load('config.toml');

    expect(config.openrouter.api_key).toBe('test-key');
    expect(config.openrouter.base_url).toBe('https://custom.api/v1');
    expect(config.openrouter.model_fast).toBe('custom/fast');
    expect(config.tokenOptimizer.enabled).toBe(false);
    expect(config.debug).toBe(true);
  });
});

describe('AIClient', () => {
  let aiClient: AIClient;
  const mockConfig = {
    api_key: 'test-key',
    base_url: 'https://openrouter.ai/api/v1',
    model_fast: 'test/fast',
    model_smart: 'test/smart',
    model_reasoning: 'test/reasoning',
  };

  beforeEach(() => {
    aiClient = new AIClient(mockConfig);
  });

  it('should initialize with correct config', () => {
    // We can't easily test private fields, but we can verify the client works
    expect(aiClient).toBeDefined();
  });

  it('should return available models', () => {
    const models = aiClient.getModels();
    
    expect(models).toHaveLength(3);
    expect(models).toContain('test/fast');
    expect(models).toContain('test/smart');
    expect(models).toContain('test/reasoning');
  });

  // Note: Actual API tests would require OPENROUTER_API_KEY and network access
  // These would be integration tests in tests/integration/
});

describe('Conventional Commits', () => {
  it('should validate commit message format', () => {
    const validCommits = [
      'feat: add new feature',
      'fix(auth): resolve login issue',
      'docs: update README',
      'refactor(core): simplify logic',
      'test: add unit tests',
      'chore: update dependencies',
      'build: configure docker',
      'ci: add github actions',
      'perf: optimize database queries',
      'style: format code',
      'revert: revert previous commit',
    ];

    const invalidCommits = [
      'added new feature',
      'fix: ',
      'invalid-type: message',
    ];

    const conventionalRegex = /^(feat|fix|perf|refactor|docs|style|test|chore|build|ci|revert)(\(.+\))?: .+/;
    
    validCommits.forEach(commit => {
      expect(commit).toMatch(conventionalRegex);
    });

    invalidCommits.forEach(commit => {
      expect(commit).not.toMatch(conventionalRegex);
    });
  });
});