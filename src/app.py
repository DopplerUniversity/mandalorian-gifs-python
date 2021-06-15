from flask import Flask, render_template, request, jsonify
from flask_cachebuster import CacheBuster
from config import config
import giphy
import utils


app = Flask(__name__)
CacheBuster(config={'extensions': ['.js', '.css', '.png'], 'hash_size': 5}).init_app(app)
print(f'\n[info]: server type is {config.SERVER}\n')


@app.route('/')
def index():
    giphy_url = giphy.get_random(config.GIPHY_API_KEY, config.GIPHY_TAG, config.GIPHY_RATING)
    return render_template('index.html', giphy_url=giphy_url)


@app.route('/webhooks/doppler-reload', methods=['POST'])
def webhook_reload():
    print('[info]: reload webhook requested')
    webhook_verified = utils.verify_doppler_webhook(request.headers['X-Doppler-Signature'], request.data)
    if webhook_verified:
        print('[info]: webhook signature verified')
        utils.trigger_reload()
        return jsonify({'reloaded': True})
    else:
        print('[info]: webhook signature was invalid')
        response = jsonify({'reloaded': False, 'error': 'webhook signature was invalid'})
        response.status_code = 401
        return response


if __name__ == '__main__':
    app.run(host='localhost', port=8080)
