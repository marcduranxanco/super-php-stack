# LARAVEL + MYSQL UNDER DOCKER

## First run
* run `make create` for create the laravel project


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
