FROM python:alpine

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
LABEL maintainer="Ryan Blunden <ryan.blunden@doppler.com>"

# Ensure DNS resolution works everywhere
# See https://github.com/gliderlabs/docker-alpine/issues/539#issuecomment-607159184
RUN apk add --no-cache bind-tools

# Use to cache bust system dependencies
ENV LAST_UPDATED 2020-12-16

# Install Doppler CLI
RUN (curl -Ls https://cli.doppler.com/install.sh || wget -qO- https://cli.doppler.com/install.sh) | sh

WORKDIR /usr/src/app

COPY requirements.txt .
RUN pip install --quiet --upgrade pip -r requirements.txt

COPY src .

EXPOSE 8080

CMD ["python", "-u", "src/app.py"]