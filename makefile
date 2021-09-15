create:
	docker-compose -f ./docker/docker-compose.yml run --rm composer install

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
