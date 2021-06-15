FROM python:3.9-alpine

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
LABEL maintainer="Ryan Blunden <ryan.blunden@doppler.com>"

# Installing bind-tools ensures DNS resolution works everywhere
# See https://github.com/gliderlabs/docker-alpine/issues/539#issuecomment-607159184
RUN apk add --no-cache bind-tools gnupg git

# Use to cache bust system dependencies
ENV LAST_UPDATED 2021-06-15

# Doppler CLI
RUN wget -q -t3 'https://packages.doppler.com/public/cli/rsa.8004D9FF50437357.key' -O /etc/apk/keys/cli@doppler-8004D9FF50437357.rsa.pub && \
    echo 'https://packages.doppler.com/public/cli/alpine/any-version/main' | tee -a /etc/apk/repositories && \
    apk add doppler

WORKDIR /usr/src/app

COPY requirements*.txt .
RUN pip install --quiet --no-cache-dir --upgrade pip setuptools && \
    pip install --quiet --no-cache-dir -r requirements.txt

COPY src .

EXPOSE 8080

CMD ["gunicorn", "app:app", "--pythonpath=src", "--pid=app.pid", "--bind=0.0.0.0:8080"]
