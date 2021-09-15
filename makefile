create:
	docker-compose -f ./docker/docker-compose.yml run --rm composer create-project laravel/laravel laravel

setup:
	sudo chmod -R 777 laravel && docker-compose -f ./docker/docker-compose.yml exec nginx chmod -R 777 /app/laravel/storage

install:
	docker-compose -f ./docker/docker-compose.yml run --rm composer install

up:
	docker-compose -f ./docker/docker-compose.yml up

down:
	docker-compose -f ./docker/docker-compose.yml down

dump:
	docker-compose -f ./docker/docker-compose.yml run --rm composer -- dump

php:
	docker-compose -f ./docker/docker-compose.yml run --rm php bash

phpunit:
	docker-compose -f ./docker/docker-compose.yml run --rm phpunit tests

composer:
	docker-compose -f ./docker/docker-compose.yml run --rm composer $(command)
