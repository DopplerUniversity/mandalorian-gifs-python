import os
from flask import Flask, render_template
from config import AppConfig
import giphy

app = Flask(__name__)
config = AppConfig(os.environ)


@app.route('/')
def index():
    giphy_url = giphy.get_random(
        config.GIPHY_API_KEY, config.GIPHY_TAG, config.GIPHY_RATING
    )
    return render_template('index.html', giphy_url=giphy_url)


if __name__ == '__main__':
    app.run(host=config.HOST, port=config.PORT)
