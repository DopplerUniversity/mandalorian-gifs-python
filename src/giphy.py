import json
from os import path
from random import randint
import requests

# The GIPHY API can be unstable sometimes so have responses in case a request fails
data_file_path = '{}/data/gifs.json'.format(path.dirname(__file__))
cached_responses = json.loads(open(data_file_path).read())

def get_cached_response():
    print('[info]:  Serving pre-cached response.')
    return cached_responses[randint(0, len(cached_responses) - 1)]['data']['images']['original']['mp4']

def get_random(api_key: str, tag: str, rating: str) -> str:
    if not api_key:
        print('[info]:  GIPHY API key not found.')
        return get_cached_response()

    resp = requests.get(
        'https://api.giphy.com/v1/gifs/random?api_key={api_key}&tag={tag}&rating={rating}'.format(
            api_key=api_key, tag=tag, rating=rating
        )
    )

    try:
        return resp.json()['data']['images']['original']['mp4']
    except KeyError as err:
        print('[error]: Expected key "{}" not found in JSON response.'.format(err))

    # Return cached response as a catch-all
    return get_cached_response()
