linting:
	docker-compose run --rm app sh -c "flake8"
testing:
	docker-compose run --rm app sh -c "python manage.py test"
build:
	docker-compose build

start:
	docker-compose up

test:
	docker-compose run --rm app sh -c "python manage.py test"

clear:
	docker-compose down

migrate:
	docker-compose run --rm app sh -c "python manage.py makemigrations"

listVol:
	docker volume ls

superuser:
	docker-compose run --rm app sh -c "python manage.py createsuperuser"

down:
	docker-compose -f docker-compose-deploy.yml down