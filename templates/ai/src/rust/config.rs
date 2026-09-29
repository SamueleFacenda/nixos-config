// config.rs
// Configuration management for Rust

use anyhow::Result;
use config::{Config as ConfigBuilder, File, FileFormat};
use serde::Deserialize;
use std::path::Path;

#[derive(Debug, Deserialize, Clone)]
pub struct OpenRouterConfig {
    pub api_key: Option<String>,
    #[serde(default = "default_base_url")]
    pub base_url: String,
    #[serde(default = "default_model_fast")]
    pub model_fast: String,
    #[serde(default = "default_model_smart")]
    pub model_smart: String,
    #[serde(default = "default_model_reasoning")]
    pub model_reasoning: String,
}

fn default_base_url() -> String {
    "https://openrouter.ai/api/v1".to_string()
}

fn default_model_fast() -> String {
    "deepseek/deepseek-chat-v3-0324:free".to_string()
}

fn default_model_smart() -> String {
    "google/gemini-2.5-flash".to_string()
}

fn default_model_reasoning() -> String {
    "openai/gpt-5".to_string()
}

#[derive(Debug, Deserialize, Clone)]
pub struct TokenOptimizerConfig {
    #[serde(default = "default_true")]
    pub enabled: bool,
    #[serde(default = "default_headroom_proxy")]
    pub headroom_proxy_url: String,
    #[serde(default = "default_true")]
    pub headroom_output_shaper: bool,
}

fn default_true() -> bool {
    true
}

fn default_headroom_proxy() -> String {
    "http://localhost:8787".to_string()
}

#[derive(Debug, Deserialize, Clone)]
pub struct MemoryConfig {
    #[serde(default = "default_global_path")]
    pub global_path: String,
    #[serde(default = "default_project_path")]
    pub project_path: String,
}

fn default_global_path() -> String {
    "~/.config/ai-memory".to_string()
}

fn default_project_path() -> String {
    ".ai-memory".to_string()
}

#[derive(Debug, Deserialize, Clone)]
pub struct Config {
    pub openrouter: OpenRouterConfig,
    #[serde(default)]
    pub token_optimizer: TokenOptimizerConfig,
    #[serde(default)]
    pub memory: MemoryConfig,
    #[serde(default)]
    pub debug: bool,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            openrouter: OpenRouterConfig {
                api_key: None,
                base_url: default_base_url(),
                model_fast: default_model_fast(),
                model_smart: default_model_smart(),
                model_reasoning: default_model_reasoning(),
            },
            token_optimizer: TokenOptimizerConfig {
                enabled: true,
                headroom_proxy_url: default_headroom_proxy(),
                headroom_output_shaper: true,
            },
            memory: MemoryConfig {
                global_path: default_global_path(),
                project_path: default_project_path(),
            },
            debug: false,
        }
    }
}

impl Config {
    /// Load configuration from file, with environment variable overrides
    pub async fn load(path: &str) -> Result<Self> {
        let path = Path::new(path);
        
        let mut builder = ConfigBuilder::default();
        
        // Load from file if it exists
        if path.exists() {
            builder = builder.add_source(File::from(path).format(FileFormat::Toml));
        }
        
        // Environment variables take precedence
        builder = builder.add_source(config::Environment::with_prefix("APP").separator("__"));
        
        let config = builder.build()?.try_deserialize()?;
        Ok(config)
    }
}