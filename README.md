# Mandalorion GIF Generator

This repository is used as part of a workshop on environment variables for app config and secrets using the [Doppler CLI](https://docs.doppler.com/docs).

The instructions below are for macOS but can easily be adapted for Linux and Windows environments.

> NOTE: If using Windows, use the [Python venv docs](https://docs.python.org/3/library/venv.html) to create and activate your virtual environment in the Command line or PowerShell.

## What is Doppler?

Doppler's secure and scalable Universal Secrets Manager seeks to make developers lives easier by removing the need for env files, hardcoded secrets, and copy-pasted credentials.

The [Doppler CLI](https://docs.doppler.com/docs) provides easy access to secrets in every environment from local development to production and a single dashboard makes it easy for teams to centrally manage app configuration for any application, platform, and cloud provider.

Learn more at our [product website](https://doppler.com) or [docs](https://docs.doppler.com/docs/).

## Requirements

- Python 3.8 or above
- Git
- Make
- [Doppler CLI](https://docs.doppler.com/docs/enclave-installation) (used to manage environment variables)
- Create a GIPHY app in order to generate an API (not SDK) key ([see instructions](https://developers.giphy.com/docs/api/#quick-start-guide))

## Local development

Setting up for local development is mostly-automated through commands in the `Makefile`, but these can be run manually if `make` is not installed.

1. Install the latest version of Python 3:
```sh
brew install python
```

2. Clone the [Mandalorion GIFs repo](https://github.com/DopplerHQ/mandalorion-gifs):
```sh
git clone https://github.com/DopplerHQ/mandalorion-gifs
```

3. Create the virtual environment:
```sh
make create-virtual-env
```

4. [Install the Doppler CLI](https://docs.doppler.com/docs/enclave-installation):
```sh
# See https://docs.doppler.com/docs/enclave-installation for other operating systems and environments, e.g. Docker
brew install dopplerhq/cli/doppler
```

5. Login and create your free Doppler account on the Community plan:
```sh
doppler login
```

6. Create the Doppler project providing the [GIPHY API KEY](https://developers.giphy.com/docs/api/#quick-start-guide):
```sh
make create-doppler-project GIPHY_API_KEY=YOUR_KEY_HERE
```

## Run app locally

Once you've created the Doppler project, you can run the app locally:

```sh
make doppler-dev
```

## Deploying the app to Heroku

Deploying to Heroku is done in three steps:

- Populate Doppler production config
- Deploy to Heroku using the Heroku CLI
- Enable the Doppler Heroku integration for the production config

### Populate Doppler production config

To prepare for deploying to Heroku, we need to populate the production (prd) Doppler environment for our project.

We do this by re-using the secrets from the **dev** environment, then updating for production usage:

```sh
make setup-doppler-production
```

### Deploy to Heroku using the Heroku CLI

To deploy the application to Heroku:

1. [Install the Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install), then login using the `heroku login` command
2. Edit the Makefile, changing `HEROKU_TEAM` to your team or account name and changing `HEROKU_APP` to be unique, e.g `mandalorion-gifs-ryan`
3. Create and deploy the app to Heroku:
```sh
make heroku-create
```

The application will deploy but won't work yet as it does not have any environment variables ([Heroku Config Vars](https://devcenter.heroku.com/articles/config-vars)) set, but we'll fix that next with Doppler's Heroku integration.

### Enable the Doppler Heroku integration for the production config

The [Doppler Heroku integration](https://docs.doppler.com/docs/heroku) enables you to automatically sync any secret changes for a config to a Heroku application.

To set up the Heroku integration:

1. Access the **mandalorion-gifs** project from the [Doppler dashboard](https://dashboard.doppler.com/), then click on **Integrations** from the projects menu on the left
2. Click on Heroku, and authorize the Doppler application
3. Doppler will then ask you to select the Heroku application and config to sync. Select `mandalorion-gifs` application and **prd** configuration

Once the integration is set up, go to the [Heroku Dashboard](https://dashboard.heroku.com/), view the settings for your application and click on **Reveal Config Vars** to see the secrets Doppler has synced across.

Your Heroku app is now ready for testing.
