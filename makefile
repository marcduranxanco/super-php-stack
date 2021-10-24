#!make
include .env
export $(shell sed 's/=.*//' .env)

create:
	docker-compose run --rm composer create-project symfony/skeleton $(NAME_PROJECT)

setup:
	sudo chmod -R 777 symfony && docker-compose exec nginx chmod -R 777 /app/$(NAME_PROJECT)/storage

install:
	docker-compose run --rm composer install

up:
	docker-compose up

down:
	docker-compose down

dump:
	docker-compose run --rm composer -- dump

php:
	docker-compose run --rm php bash

phpunit:
	docker-compose run --rm phpunit tests

composer:
	docker-compose run --rm composer $(command)
