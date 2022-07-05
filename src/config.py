import os
from dotenv import load_dotenv
from app_config_base import AppConfigBase


if os.path.exists('.env'):
    print('\n[info]: Configuration loaded from Doppler mounted .env file\n')
    with open ('.env') as env_file:
        load_dotenv(stream=open ('.env'))

if os.environ.get('DOPPLER_PROJECT'):
  print(f'\n[info]: Configuration loaded from Doppler ({os.environ["DOPPLER_PROJECT"]} => {os.environ["DOPPLER_CONFIG"]})\n')

class AppConfig(AppConfigBase):
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
