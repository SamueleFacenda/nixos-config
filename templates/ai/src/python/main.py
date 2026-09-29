# -*- coding: utf-8 -*-
"""
{{project_name}} - AI-assisted development project

{{project_description}}

This is a template for AI-assisted development projects using OpenRouter.
It follows clean code principles with minimal comments (only WHY/ALGORITHM/TODO).
"""

import asyncio
import logging
from pathlib import Path
from typing import Optional

import typer
from loguru import logger
from pydantic_settings import BaseSettings, SettingsConfigDict
from rich.console import Console

# Configure logging
logger.remove()
logger.add(
    lambda msg: print(msg, end=""),
    level="INFO",
    format="<green>{time:HH:mm:ss}</green> | <level>{level: <8}</level> | <cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> - <level>{message}</level>"
)

console = Console()


class Config(BaseSettings):
    """Application configuration loaded from environment variables."""
    
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )
    
    # OpenRouter configuration
    openrouter_api_key: str = ""
    openrouter_base_url: str = "https://openrouter.ai/api/v1"
    
    # Model selection
    model_fast: str = "deepseek/deepseek-chat-v3-0324:free"
    model_smart: str = "google/gemini-2.5-flash"
    model_reasoning: str = "openai/gpt-5"
    
    # Token optimization
    token_optimizer_enabled: bool = True
    headroom_proxy_url: str = "http://localhost:8787"
    headroom_output_shaper: bool = True
    
    # Memory
    memory_global_path: str = "~/.config/ai-memory"
    memory_project_path: str = ".ai-memory"
    
    # Debug
    debug: bool = False


class AIClient:
    """OpenRouter AI client."""
    
    def __init__(self, config: Config) -> None:
        self.config = config
        # TODO: Initialize async OpenAI client with OpenRouter base URL
        # WHY: Using OpenRouter as the single provider for all models
    
    async def chat(self, message: str, model: Optional[str] = None) -> str:
        """Send a chat message and get response."""
        # TODO: Implement actual API call
        # ALGORITHM: Use async-openai client with OpenRouter endpoint
        logger.info(f"Sending message to model: {model or self.config.model_smart}")
        return f"Response to: {message}"


async def main(config_path: Optional[str] = None, debug: bool = False) -> None:
    """Main application entry point."""
    console.print(f"🚀 [bold green]{{project_name}}[/bold green] v0.1.0")
    console.print(f"   {{{{project_description}}}}")
    console.print()
    
    # Load configuration
    config = Config()
    if debug:
        config.debug = True
        logger.level("DEBUG")
    
    logger.info("Configuration loaded")
    
    # Initialize AI client
    ai_client = AIClient(config)
    logger.info("AI client initialized")
    
    # Run main logic
    await run(ai_client)
    
    logger.info("Done")


async def run(ai_client: AIClient) -> None:
    """Run the main application logic."""
    # TODO: Implement main application logic
    # WHY: This is a template - replace with actual implementation
    logger.info("Application running - replace with actual logic")
    
    # Example usage:
    # response = await ai_client.chat("Hello, world!")
    # logger.info(f"AI response: {response}")


def cli() -> None:
    """CLI entry point for typer."""
    typer.run(main)


if __name__ == "__main__":
    cli()