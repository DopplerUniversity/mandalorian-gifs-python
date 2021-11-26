SHELL=/bin/bash
VENVDIR?=${HOME}/.virtualenvs
WORKDIR?=$(shell basename "$$PWD")
VENV?=$(VENVDIR)/$(WORKDIR)/bin
PYTHON?=$(VENV)/python
ACTIVATE?=$(VENV)/activate

create-virtual-env:
	mkdir -p ~/.virtualenvs && \
	python3 -m venv $(VENVDIR)/$(WORKDIR) && \
	. $(ACTIVATE) && \
	pip install --upgrade pip setuptools && \
	pip install -r requirements-dev.txt

activate:
	. $(ACTIVATE)

# USAGE: make create-doppler-project GIPHY_API_KEY=XXXX
create-doppler-project:
	@./bin/create-doppler-project.sh

dev:
	doppler run -- $(PYTHON) src/app.py

lint:
	flake8 --ignore E501 src

format:
	black --skip-string-normalization --line-length 120 src

gunicorn:
	doppler run -- gunicorn \
		app:app \
		--pythonpath=src \
		--pid app.pid \
		--reload \
		--workers 1 \
		--bind localhost:8080

env-file-dev:
	. ~/.virtualenvs/mandalorian-gifs/bin/activate && \
	. ./sample.env && \
	python3 src/app.py


############
#  Docker  #
############

CONTAINER_NAME=mandalorian-gifs-python
IMAGE_NAME=doppleruniversity/mandalorian-gifs-python

docker-build:
	docker image pull python:alpine
	docker image build -t $(IMAGE_NAME):latest .

docker:
	# Runs as root user in order to install dev packages
	docker container run \
		-it \
		--init \
		--rm \
		--name mandalorian-gifs \
		-v $(shell pwd):/usr/src/app:cached \
		-u root \
		-p 8080:8080 \
		--env-file <(doppler secrets download --no-file --format docker) \
		$(IMAGE_NAME) $(CMD)

docker-exec:
	docker exec -it mandalorian-gifs sh

############
#  HEROKU  #
############

HEROKU_TEAM=doppleruniversity
HEROKU_APP=mandalorian-gifs

heroku-create:
	heroku apps:create --team $(HEROKU_TEAM) $(HEROKU_APP)
	git remote rename heroku $(HEROKU_APP)
	$(MAKE) heroku-deploy HEROKU_APP=$(HEROKU_APP)

heroku-deploy:
	git push $(HEROKU_APP) master -f
	heroku open --app $(HEROKU_APP)

heroku-destroy:
	heroku apps:destroy --app $(HEROKU_APP) --confirm $(HEROKU_APP)
