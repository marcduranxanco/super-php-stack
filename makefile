#!make
include .env
export $(shell sed 's/=.*//' .env)

create:
	docker-compose -f .env -f ./docker/docker-compose.yml run --rm composer create-project laravel/laravel $(NAME_PROJECT)

setup:
	sudo chmod -R 777 $(NAME_PROJECT) && docker-compose -f ./docker/docker-compose.yml exec nginx chmod -R 777 /app/storage

up:
	docker-compose -f ./docker/docker-compose.yml up -d

down:
	docker-compose -f ./docker/docker-compose.yml down

php:
	docker-compose -f ./docker/docker-compose.yml run --rm php bash

# phpunit:
# 	docker-compose -f ./docker/docker-compose.yml run --rm phpunit tests