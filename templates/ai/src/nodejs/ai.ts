// ai.ts
// OpenRouter AI client for Node.js

import OpenAI from 'openai';
import { OpenRouterConfig } from './config.js';

export class AIClient {
  private client: OpenAI;
  private config: OpenRouterConfig;

  constructor(config: OpenRouterConfig) {
    this.config = config;
    
    // Initialize OpenAI client with OpenRouter endpoint
    this.client = new OpenAI({
      apiKey: config.api_key || process.env.OPENROUTER_API_KEY,
      baseURL: config.base_url,
      dangerouslyAllowBrowser: false,
    });
  }

  /**
   * Send a chat message and get response
   * @param message - User message
   * @param model - Model to use (defaults to smart model)
   * @returns AI response
   */
  async chat(message: string, model?: string): Promise<string> {
    const selectedModel = model || this.config.model_smart;
    
    try {
      const completion = await this.client.chat.completions.create({
        model: selectedModel,
        messages: [
          {
            role: 'user',
            content: message,
          },
        ],
        temperature: 0.7,
        max_tokens: 4096,
      });

      return completion.choices[0]?.message?.content || 'No response';
    } catch (error) {
      console.error('AI chat error:', error);
      throw error;
    }
  }

  /**
   * Send a chat message with system prompt
   * @param systemPrompt - System prompt
   * @param userMessage - User message
   * @param model - Model to use
   * @returns AI response
   */
  async chatWithSystem(systemPrompt: string, userMessage: string, model?: string): Promise<string> {
    const selectedModel = model || this.config.model_smart;
    
    try {
      const completion = await this.client.chat.completions.create({
        model: selectedModel,
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userMessage },
        ],
        temperature: 0.7,
        max_tokens: 4096,
      });

      return completion.choices[0]?.message?.content || 'No response';
    } catch (error) {
      console.error('AI chat with system error:', error);
      throw error;
    }
  }

  /**
   * Stream chat response
   * @param message - User message
   * @param model - Model to use
   * @param onChunk - Callback for each chunk
   * @returns Full response
   */
  async *streamChat(message: string, model?: string): AsyncGenerator<string, string, unknown> {
    const selectedModel = model || this.config.model_smart;
    let fullResponse = '';

    try {
      const stream = await this.client.chat.completions.create({
        model: selectedModel,
        messages: [{ role: 'user', content: message }],
        temperature: 0.7,
        max_tokens: 4096,
        stream: true,
      });

      for await (const chunk of stream) {
        const content = chunk.choices[0]?.delta?.content || '';
        fullResponse += content;
        yield content;
      }

      return fullResponse;
    } catch (error) {
      console.error('AI stream chat error:', error);
      throw error;
    }
  }

  /**
   * Get available models from OpenRouter
   * @returns List of available models
   */
  async getModels(): Promise<string[]> {
    try {
      // This would require a different API endpoint
      // For now, return our configured models
      return [
        this.config.model_fast,
        this.config.model_smart,
        this.config.model_reasoning,
      ];
    } catch (error) {
      console.error('Get models error:', error);
      return [];
    }
  }
}