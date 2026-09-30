// ai.rs
// OpenRouter AI client for Rust

use anyhow::Result;
use async_openai::{
    config::OpenAIConfig,
    Client as OpenAIClient,
    types::{
        ChatCompletionRequestMessage, ChatCompletionRequestSystemMessageArgs,
        ChatCompletionRequestUserMessageArgs, CreateChatCompletionRequestArgs,
    },
};
use crate::config::OpenRouterConfig;

pub struct AIClient {
    client: OpenAIClient<OpenAIConfig>,
    config: OpenRouterConfig,
}

impl AIClient {
    pub fn new(config: OpenRouterConfig) -> Self {
        let openai_config = OpenAIConfig::new()
            .with_api_key(config.api_key.unwrap_or_else(|| {
                std::env::var("OPENROUTER_API_KEY").unwrap_or_default()
            }))
            .with_api_base(config.base_url.clone());
        
        let client = OpenAIClient::with_config(openai_config);
        
        Self { client, config }
    }

    /// Send a chat message and get response
    pub async fn chat(&self, message: &str, model: Option<&str>) -> Result<String> {
        let selected_model = model.unwrap_or(&self.config.model_smart);
        
        let request = CreateChatCompletionRequestArgs::default()
            .model(selected_model)
            .messages(vec![
                ChatCompletionRequestUserMessageArgs::default()
                    .content(message)
                    .build()?
                    .into(),
            ])
            .temperature(0.7)
            .max_tokens(4096_u16)
            .build()?;

        let response = self.client.chat().create(request).await?;
        
        Ok(response.choices[0].message.content.clone().unwrap_or_default())
    }

    /// Send a chat message with system prompt
    pub async fn chat_with_system(
        &self,
        system_prompt: &str,
        user_message: &str,
        model: Option<&str>,
    ) -> Result<String> {
        let selected_model = model.unwrap_or(&self.config.model_smart);
        
        let request = CreateChatCompletionRequestArgs::default()
            .model(selected_model)
            .messages(vec![
                ChatCompletionRequestSystemMessageArgs::default()
                    .content(system_prompt)
                    .build()?
                    .into(),
                ChatCompletionRequestUserMessageArgs::default()
                    .content(user_message)
                    .build()?
                    .into(),
            ])
            .temperature(0.7)
            .max_tokens(4096_u16)
            .build()?;

        let response = self.client.chat().create(request).await?;
        
        Ok(response.choices[0].message.content.clone().unwrap_or_default())
    }

    /// Get available models
    pub fn available_models(&self) -> Vec<&str> {
        vec![
            &self.config.model_fast,
            &self.config.model_smart,
            &self.config.model_reasoning,
        ]
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_ai_client_creation() {
        let config = OpenRouterConfig {
            api_key: Some("test-key".to_string()),
            base_url: "https://openrouter.ai/api/v1".to_string(),
            model_fast: "test/fast".to_string(),
            model_smart: "test/smart".to_string(),
            model_reasoning: "test/reasoning".to_string(),
        };
        let client = AIClient::new(config);
        
        let models = client.available_models();
        assert_eq!(models.len(), 3);
        assert!(models.contains(&"test/fast"));
        assert!(models.contains(&"test/smart"));
        assert!(models.contains(&"test/reasoning"));
    }
}