#!make
include .env
export $(shell sed 's/=.*//' .env)

setup:
	sudo chmod -R 777 /app/$(NAME_PROJECT) && docker compose exec nginx chmod -R 777 /app/$(NAME_PROJECT)/storage

up:
	docker-compose up -d

down:
	docker-compose down

bash:
	docker-compose exec php bash

tests:
	docker-compose run php vendor/bin/phpunit tests
