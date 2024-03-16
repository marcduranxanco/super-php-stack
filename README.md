# DOCKER WITH PHP + MYSQL

# About this project
This project is prepared to be executed with Docker. 
It has a makefile that allows you to perform the main actions.

# Instructions for initializing the project with Symfony
## Create a new project and first run
- Merge the current branch to main
    ```
    git checkout origin/docker-symfony-mysql
    git merge --strategy=ours main #git merge --allow-unrelated-histories -s ours main
    git checkout main
    git merge origin/docker-symfony-mysql
    ```
- Remove unused branches and 
- Create the .env file from the .env.example and set the variables
- Copy or create the project on the app folder
```
# Access to the container
make bash

# Install the project
composer create-project symfony/skeleton:"7.0.*" .
composer require webapp1
```
 (`composer create-project symfony/skeleton PROJECT_NAME`) or if you don't have composer in your system, you can use the composer container and makefile `make create` (it will use the PROJECT_NAME from .env)
- Add the phpunit to the project: `composer require --dev phpunit/phpunit` and `composer install`
- Set up the project with `make setup` [WARNING] - This environtment is for development purposes. This command, makes unsafe environtment for security
- Start the project `make up`

## Update the database environtment variables
```
...
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=symfony
DB_USERNAME=root
DB_PASSWORD=Default-Root-Password
...
```

## Make description
- `make setup`: Set up the project. Apply 777 permissions on the storage project directory
- `make up`: starts the docker containers
- `make down`: stops the docker containers
- `make bash`: access to the php container
- `make tests`: runs the project tests

# Main docker-compose commands

Add phpunit and test it
```
docker-compose run composer require --dev phpunit/phpunit
docker-compose run php vendor/bin/phpunit
docker-compose run phpunit --version
```

Run phpunit tests
```
docker-compose run --rm phpunit tests
```

Run phpunit tests
```
docker-compose up -d fpm nginx
```

Composer dump autoload
```
docker-compose run composer -- dump
```
