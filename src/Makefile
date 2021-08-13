flask:
	doppler run -- python app.py

gunicorn:
	gunicorn \
		app:app \
		--pythonpath=src \
		--pid app.pid \
		--reload \
		--workers 1 \
		--bind localhost:8080
