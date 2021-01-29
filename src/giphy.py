import json
from os import path
from random import randint
import requests

# The GIPHY API can be unstable sometimes so have responses in case a request fails
data_file_path = '{}/data/cached-giphy-responses.json'.format(path.dirname(__file__))
cached_responses = json.loads(open(data_file_path).read())


def get_random(api_key: str, tag: str, rating: str) -> str:
    resp = requests.get(
        'https://api.giphy.com/v1/gifs/random?api_key={api_key}&tag={tag}&rating={rating}'.format(
            api_key=api_key, tag=tag, rating=rating
        )
    )

    try:
        return resp.json()['data']['images']['original']['mp4']
    except KeyError as err:
        print('[error]: Expected key not found in JSON response: {}. Serving random cached response.'.format(err))

    # Return cached response as a catch-all
    return cached_responses[randint(0, len(cached_responses)-1)]['data']['images']['original']['mp4']
