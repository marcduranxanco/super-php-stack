# DOCKER WITH PHP + MYSQL

# About this project
This project is prepared to be executed with Docker. 
It has a makefile that allows you to perform the main actions.

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

## Update the database environtment variables
```
...
MYSQL_PORT=3306
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=symfony
MYSQL_USER=symfony
MYSQL_PASSWORD=symfony
...
```

# Symfony installation
```
# Access to the container
make bash

# Install the project
composer create-project symfony/skeleton:"7.0.*" .
composer require webapp
```

- Set up the project with `make setup` [WARNING] - This environtment is for development purposes. This command, makes unsafe environtment for security
- Update de database conection in the .env project file: `DATABASE_URL="mysql://MYSQL_USER:MYSQL_PASSWORD@127.0.0.1:3306/MYSQL_DATABASE?serverVersion=5.7&charset=utf8mb4"`
- Start the project `make up`

## Make description
- `make setup`: Set up the project. Apply 777 permissions on the storage project directory
- `make up`: starts the docker containers
- `make down`: stops the docker containers
- `make bash`: access to the php container
- `make tests`: runs the project tests

# Main docker-compose commands

Add phpunit and test it
```
docker-compose run php vendor/bin/phpunit
docker-compose run php vendor/bin/phpunit --version
```

Run phpunit tests
```
docker-compose run php vendor/bin/phpunit tests
```