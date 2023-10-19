# LARAVEL + MYSQL UNDER DOCKER

# About this project
This project is prepared to be executed with Docker. 
It has a makefile that allows you to perform the main actions.

## Create a new project and first run
- Merge the current branch to main
  - `git checkout main`
  - `git merge --allow-unrelated-histories docker-laravel-mysql`
  - If there are, resolve the conflicts
  - git commit
  - git push origin/main
- - Opcional: `git branch -D docker-laravel-mysql`

- Create the .env file from the .env.example and set the variables (for the `project` and for `docker` variables)
- Copy or create the project on the app folder (composer create-project symfony/skeleton PROJECT_NAME) or if you don't have composer in your system, you can use the composer container and makefile make create (it will use the PROJECT_NAME from .env)
- Add the phpunit to the project: composer require --dev phpunit/phpunit and composer install
- Create the project with `make create`
- Set up the project with `make setup` [WARNING] - This environtment is for development purposes. This command, makes unsafe environtment for security
- Start the project `make up`


## Update the database environtment variables
```
...
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=root
DB_PASSWORD=Default-Root-Password
...
```


## Make description
- `make create`: creates the laravel project (under the laravel directory)
- `make install`: install the dependencies 
- `make up`: starts the docker containers
- `make down`: stops the docker containers
- `make dump`: run the composer -- dump
- `make dumpo`: composer dump -o
- `make php`: access to the php container
- `make run`-tests: runs the project tests
- `make robot`: starts the cli project



```

echo 'vendor/' >> .gitignore
echo 'var/' >> .gitignore
```

# Main commands

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
