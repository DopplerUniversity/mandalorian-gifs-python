from app_config_base import AppConfigBase


class AppConfig(AppConfigBase):
    FLASK_ENV: str = 'production'
    SECRET_KEY: str
    HOST: str
    PORT: int
    GIPHY_API_KEY: str = ''  # Empty string default required as VS Code Python debugger strips env vars without values
    GIPHY_TAG: str
    GIPHY_RATING: str
