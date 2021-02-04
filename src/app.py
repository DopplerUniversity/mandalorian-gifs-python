import os
from flask import Flask, render_template
from flask_cachebuster import CacheBuster
from config import AppConfig
import giphy


app = Flask(__name__)
CacheBuster(config={'extensions': ['.js', '.css', '.png'], 'hash_size': 5}).init_app(app)
config = AppConfig(os.environ)


@app.route('/')
def index():
    giphy_url = giphy.get_random(
        config.GIPHY_API_KEY, config.GIPHY_TAG, config.GIPHY_RATING
    )
    return render_template('index.html', giphy_url=giphy_url)


if __name__ == '__main__':
    app.run(host=config.HOST, port=config.PORT)
