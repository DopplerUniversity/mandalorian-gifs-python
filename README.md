# Mandalorian GIF Generator

![Mandalorian GIFs screenshot](https://repository-images.githubusercontent.com/334072139/f5912289-ef41-4347-99a7-2e820a95a8ba)

Random Mandalorian GIFs generator using [Doppler](https://www.doppler.com) for managing app configuration and secrets via environment variables.

[![Import to Doppler](https://raw.githubusercontent.com/DopplerUniversity/app-config-templates/main/doppler-button.svg)](https://dashboard.doppler.com/workplace/template/import?template=https://github.com/DopplerUniversity/mandalorian-gifs-python/blob/main/doppler-template.yaml)

## What is Doppler?

Doppler's secure and scalable Universal Secrets Manager seeks to make developers lives easier by removing the need for env files, hardcoded secrets, and copy-pasted credentials.

The [Doppler CLI](https://docs.doppler.com/docs) provides easy access to secrets in every environment from local development to production and a single dashboard makes it easy for teams to centrally manage app configuration for any application, platform, and cloud provider.

Learn more at our [product website](https://doppler.com) or [docs](https://docs.doppler.com/docs/).

## Requirements

- Python 3.9 or above
- Git
- Make
- [Doppler CLI](https://docs.doppler.com/docs/enclave-installation) (used to manage environment variables)
- Create a GIPHY app in order to generate an API (not SDK) key ([see instructions](https://developers.giphy.com/docs/api/#quick-start-guide))

The instructions following are for macOS but can easily be adapted for Linux and Windows environments.

> NOTE: If using Windows, use the [Python venv docs](https://docs.python.org/3/library/venv.html) to create and activate your virtual environment in the Terminal or PowerShell.

## Local development

Setting up for local development is mostly-automated through commands in the `Makefile`, but these can be run manually if `make` is not installed.

1. Install the latest version of Python 3:

```sh
brew install python
```

2. Clone the [Mandalorian GIFs repo](https://github.com/DopplerUniversity/mandalorian-gifs-python):

```sh
git clone https://github.com/DopplerUniversity/mandalorian-gifs-python
```

3. Create the virtual environment (which includes installing dev dependencies):

```sh
make create-virtual-env
```

4. Activate virtual environment:

```sh
eval $(make activate)
```

5. [Install the Doppler CLI](https://docs.doppler.com/docs/enclave-installation):

```sh
# See https://docs.doppler.com/docs/enclave-installation for other operating systems and environments, e.g. Docker
brew install dopplerhq/cli/doppler
```

6. Login and create your free Doppler account on the Community plan:

```sh
doppler login
```

7. Create the Doppler project providing the [GIPHY API KEY](https://developers.giphy.com/docs/api/#quick-start-guide):

```sh
make create-doppler-project GIPHY_API_KEY=YOUR_KEY_HERE
```

## Run app locally

Once you've created the Doppler project, you can run the app locally:

```sh
make dev
```

## Visual Studio Code

### Debugging locally

To debug in Visual Studio code, simply run the `python: server` launch configuration.


### Debugging in a dev container

To debug in a Dev Container, you'll need to open the project using the `code` binary from an external terminal window in order to set the environment variables required by the container.

To do this:

1. Close this project in Visual Studio Code
2. Open a new terminal 
3. Change into the `mandalorian-gifs` directory
4. Launch Visual Studio Code from the terminal and setting the required Doppler environment variables:

```sh
DOPPLER_TOKEN=$(doppler configure get token --plain) \
DOPPLER_PROJECT=$(doppler configure get project --plain) \
DOPPLER_CONFIG=$(doppler configure get config --plain) \
code .
```

Now re-open the project as a dev container by running the command: `Remote-Containers: Rebuild and Reopen in Container`.

The once the dev container has been built and is ready, run the `python: dev container` launch configuration.

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
2. Edit the Makefile, changing `HEROKU_TEAM` to your team or account name and changing `HEROKU_APP` to be unique, e.g `mandalorian-gifs-ryan`
3. Create and deploy the app to Heroku:
```sh
make heroku-create
```

The application will deploy but won't work yet as it does not have any environment variables ([Heroku Config Vars](https://devcenter.heroku.com/articles/config-vars)) set, but we'll fix that next with Doppler's Heroku integration.

### Enable the Doppler Heroku integration for the production config

The [Doppler Heroku integration](https://docs.doppler.com/docs/heroku) enables you to automatically sync any secret changes for a config to a Heroku application.

To set up the Heroku integration:

1. Access the **mandalorian-gifs** project from the [Doppler dashboard](https://dashboard.doppler.com/), then click on **Integrations** from the projects menu on the left
2. Click on Heroku, and authorize the Doppler application
3. Doppler will then ask you to select the Heroku application and config to sync. Select `mandalorian-gifs` application and **prd** configuration

Once the integration is set up, go to the [Heroku Dashboard](https://dashboard.heroku.com/), view the settings for your application and click on **Reveal Config Vars** to see the secrets Doppler has synced across.

Your Heroku app is now ready for testing.
