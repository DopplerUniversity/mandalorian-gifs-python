#!/usr/bin/env bash

# Runs as root user in order to install dev packages
docker container run \
-it \
--init \
--rm \
--name mandalorion-gifs \
-v $(pwd):/usr/src/app:cached \
-u root \
--env-file <(doppler secrets download --no-file --format docker) \
-p $(doppler secrets get PORT --plain):$(doppler secrets get PORT --plain) \
dopplerhq/mandalorion-gifs:latest
