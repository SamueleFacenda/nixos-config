// Unit tests for Rust code
// Run with: cargo nextest run --profile=ci

use {{project_name}}::{Config, AIClient};

#[tokio::test]
async fn test_config_defaults() {
    let config = Config::default();
    
    assert_eq!(config.openrouter.base_url, "https://openrouter.ai/api/v1");
    assert_eq!(config.openrouter.model_fast, "deepseek/deepseek-chat-v3-0324:free");
    assert_eq!(config.openrouter.model_smart, "google/gemini-2.5-flash");
    assert_eq!(config.openrouter.model_reasoning, "openai/gpt-5");
    assert!(config.token_optimizer.enabled);
    assert_eq!(config.token_optimizer.headroom_proxy_url, "http://localhost:8787");
    assert!(config.token_optimizer.headroom_output_shaper);
}

#[tokio::test]
async fn test_ai_client_creation() {
    let config = Config::default();
    let client = AIClient::new(config.openrouter);
    
    let models = client.available_models();
    assert_eq!(models.len(), 3);
    assert!(models.contains(&"deepseek/deepseek-chat-v3-0324:free"));
    assert!(models.contains(&"google/gemini-2.5-flash"));
    assert!(models.contains(&"openai/gpt-5"));
}

// Note: Integration tests with actual API calls would go in tests/integration/
// and require OPENROUTER_API_KEY to be set