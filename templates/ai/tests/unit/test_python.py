# Unit tests for Python code
# Run with: uv run pytest tests/unit/test_python.py -v

import pytest
from unittest.mock import AsyncMock, patch
import sys
from pathlib import Path

# Add src to path
sys.path.insert(0, str(Path(__file__).parent.parent.parent / "src" / "python"))

from main import Config, AIClient


class TestConfig:
    """Test configuration loading."""
    
    def test_default_config(self):
        """Test default configuration values."""
        config = Config()
        
        assert config.openrouter_base_url == "https://openrouter.ai/api/v1"
        assert config.model_fast == "deepseek/deepseek-chat-v3-0324:free"
        assert config.model_smart == "google/gemini-2.5-flash"
        assert config.model_reasoning == "openai/gpt-5"
        assert config.token_optimizer_enabled is True
        assert config.headroom_proxy_url == "http://localhost:8787"
        assert config.headroom_output_shaper is True
    
    def test_config_from_env(self, monkeypatch):
        """Test configuration from environment variables."""
        monkeypatch.setenv("OPENROUTER_API_KEY", "test-key")
        monkeypatch.setenv("MODEL_FAST", "custom/fast-model")
        monkeypatch.setenv("DEBUG", "true")
        
        config = Config()
        
        assert config.openrouter_api_key == "test-key"
        assert config.model_fast == "custom/fast-model"
        assert config.debug is True


class TestAIClient:
    """Test AI client."""
    
    @pytest.fixture
    def config(self):
        """Create test config."""
        return Config(
            openrouter_api_key="test-key",
            model_fast="test/fast",
            model_smart="test/smart",
            model_reasoning="test/reasoning"
        )
    
    @pytest.fixture
    def ai_client(self, config):
        """Create AI client."""
        return AIClient(config)
    
    def test_client_initialization(self, ai_client):
        """Test AI client initializes correctly."""
        assert ai_client.config.openrouter_api_key == "test-key"
        assert ai_client.config.model_smart == "test/smart"
    
    @pytest.mark.asyncio
    async def test_chat_mock(self, ai_client):
        """Test chat with mocked response."""
        # Mock the actual API call
        with patch.object(ai_client, 'chat', new_callable=AsyncMock) as mock_chat:
            mock_chat.return_value = "Mocked response"
            
            response = await ai_client.chat("Hello")
            
            assert response == "Mocked response"
            mock_chat.assert_called_once_with("Hello", None)
    
    @pytest.mark.asyncio
    async def test_chat_with_model(self, ai_client):
        """Test chat with specific model."""
        with patch.object(ai_client, 'chat', new_callable=AsyncMock) as mock_chat:
            mock_chat.return_value = "Model specific response"
            
            response = await ai_client.chat("Hello", model="custom/model")
            
            assert response == "Model specific response"
            mock_chat.assert_called_once_with("Hello", "custom/model")


# Integration tests would go in tests/integration/ and require OPENROUTER_API_KEY