# LARAVEL + MYSQL UNDER DOCKER

# About this project
This project is prepared to be executed with Docker. 
It has a makefile that allows you to perform the main actions.

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
