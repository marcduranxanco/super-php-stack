FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql

COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /app