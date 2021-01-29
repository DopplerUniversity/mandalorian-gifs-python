from app_config_base import AppConfigBase

class AppConfig(AppConfigBase):
    FLASK_ENV: str
    SECRET_KEY: str
    HOST: str
    PORT: int
    GIPHY_API_KEY: str
    GIPHY_TAG: str
    GIPHY_RATING: str
