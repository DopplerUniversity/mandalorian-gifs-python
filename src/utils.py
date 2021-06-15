import hashlib
import hmac
import subprocess

from config import config


def verify_doppler_webhook(doppler_signature: str, payload: bytes):
    computed_signature = hmac.new(key=config.WEBHOOK_SECRET, msg=payload, digestmod=hashlib.sha256).hexdigest()
    return hmac.compare_digest(doppler_signature.replace('sha256=', ''), computed_signature)


def trigger_reload():
    if config.SERVER == 'gunicorn':
        pid = open('app.pid').read().strip()
        print('[info]: triggering reload of gunicorn server\n')
        subprocess.run(['kill', '-HUP', pid], capture_output=True)
    else:
        print('[info]: reload aborted as gunicorn is required\n')
