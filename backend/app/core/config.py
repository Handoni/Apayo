from pydantic_settings import BaseSettings, SettingsConfigDict
import os


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=f"{os.path.dirname(os.path.abspath(__file__))}/../.env",
        env_file_encoding="utf-8",
    )
    gpt_api_key: str
    gpt_api_url: str = "https://api.openai.com/v4/completions"
    google_application_credentials: str
    token_secret: str
    token_algorithm: str
    token_expire_minutes: int

def get_settings() -> Settings:
    settings = Settings()  # type: ignore
    return settings


get_settings()
