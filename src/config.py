import os
from app_config_base import AppConfigBase


class AppConfig(AppConfigBase):
    FLASK_ENV: str = 'production'
    SECRET_KEY: str
    GIPHY_API_KEY: str = ''  # Empty string default required as VS Code Python debugger strips env vars without values
    GIPHY_TAG: str
    GIPHY_RATING: str
    WEBHOOK_SECRET: bytes
    SERVER: str = ''

    def _parse_webhook_secret(self, WEBHOOK_SECRET):
        return bytes(WEBHOOK_SECRET, 'utf-8')

    def _parse_server(self, SERVER):
        return 'gunicorn' if 'gunicorn' in os.environ.get('SERVER_SOFTWARE', '') else 'flask'


config = AppConfig(os.environ)
