FROM php:8.2-fpm

# Instala extensiones comunes
RUN apt-get update && apt-get install -y \
    git unzip libicu-dev libpq-dev libzip-dev zip \
    && docker-php-ext-install intl pdo pdo_mysql zip opcache

# Instala Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

ARG USER_ID=1001
ARG GROUP_ID=1001
RUN groupadd -g ${GROUP_ID} appgroup \
    && useradd -u ${USER_ID} -g ${GROUP_ID} -m appuser

USER appuser

WORKDIR /var/www/html
