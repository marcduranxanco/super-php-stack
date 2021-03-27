# SUPER PHP STACK

Documentation: https://thephp.website/en/issue/php-docker-quick-setup/

## First run
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