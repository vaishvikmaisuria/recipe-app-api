linting:
	docker-compose run --rm app sh -c "flake8"
testing:
	docker-compose run --rm app sh -c "python manage.py test"
build:
	docker-compose build 

start:
	docker-compose up