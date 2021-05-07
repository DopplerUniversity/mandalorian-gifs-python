FROM python:3.9-alpine

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
LABEL maintainer="Ryan Blunden <ryan.blunden@doppler.com>"

# Installing bind-tools ensures DNS resolution works everywhere
# See https://github.com/gliderlabs/docker-alpine/issues/539#issuecomment-607159184
RUN apk add --no-cache bind-tools gnupg git

# Use to cache bust system dependencies
ENV LAST_UPDATED 2021-05-07

# Install Doppler CLI
RUN (curl -Ls https://cli.doppler.com/install.sh || wget -qO- https://cli.doppler.com/install.sh) | sh

WORKDIR /usr/src/app

COPY requirements.txt .
RUN pip install --quiet --no-cache-dir --upgrade pip setuptools  -r requirements.txt

COPY src .

EXPOSE 8080

CMD ["gunicorn", "--pythonpath", "src", "app:app"]
