create-virtual-env:
	mkdir -p ~/.virtualenvs && \
	python3 -m venv ~/.virtualenvs/mandalorion-gifs && \
	. ~/.virtualenvs/mandalorion-gifs/bin/activate && \
	pip install --upgrade pip -r requirements.txt
	@echo '[info]: Now run `. ~/.virtualenvs/mandalorion-gifs/bin/activate` to activate the virtual environment'

# USAGE: make create-doppler-project GIPHY_API_KEY=XXXX
create-doppler-project:
	@echo '[info]: Creating "mandalorion-gifs" project'
	doppler projects create mandalorion-gifs
	doppler setup
	@echo '[info]: Uploading default secrets'
	doppler secrets upload sample.env
	@echo '[info]: Randomizing Flask secret key'
	doppler secrets set SECRET_KEY "$(shell python -c 'import uuid; print(uuid.uuid4())')"
	@echo '[info]: Setting GIPHY API KEY'
	doppler secrets set	GIPHY_API_KEY="$(GIPHY_API_KEY)"

dev:
	. ~/.virtualenvs/mandalorion-gifs/bin/activate && \
	doppler run -- python src/app.py

gunicorn:
	. ~/.virtualenvs/mandalorion-gifs/bin/activate && \
	doppler run -- gunicorn --pythonpath src app:app

env-file-dev:
	. ~/.virtualenvs/mandalorion-gifs/bin/activate && \
	. sample.env && \
	python3 src/app.py


############
#  Docker  #
############

CONTAINER_NAME=mandalorion-gifs
IMAGE_NAME=dopplerhq/mandalorion-gifs

docker-build:
	docker image build -t $(IMAGE_NAME):latest .

docker:
	./bin/docker.sh


############
#  HEROKU  #
############

HEROKU_TEAM=dagobah-systems
HEROKU_APP=mandalorion-gifs

heroku-create:
	heroku apps:create --team $(HEROKU_TEAM) $(HEROKU_APP)
	$(MAKE) heroku-deploy HEROKU_APP=$(HEROKU_APP)

heroku-deploy:
	git push $(HEROKU_APP)
	heroku open --app $(HEROKU_APP)

heroku-destroy:
	heroku apps:destroy --app $(HEROKU_APP) --confirm $(HEROKU_APP)
