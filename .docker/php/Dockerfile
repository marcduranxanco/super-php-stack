FROM dunglas/frankenphp:php8.4

ARG UID=1000
ARG GID=1000

RUN apt-get update && apt-get install -y \
    git unzip libicu-dev libpq-dev libzip-dev \
    && install-php-extensions \
        @composer \
        intl \
        pdo_pgsql \
        opcache \
        zip \
    && rm -rf /var/lib/apt/lists/*

# Ajuste de usuario www-data al UID/GID del host
RUN groupmod -g ${GID} www-data \
 && usermod -u ${UID} -g ${GID} www-data

RUN mkdir -p /data/caddy/pki/authorities \
             /data/caddy/certificates \
             /config/caddy \
             /app/var/cache \
             /app/var/log && \
    chown -R www-data:www-data /data /config /app/var

VOLUME ["/data", "/config"]

WORKDIR /app

COPY ./php/php.ini /usr/local/etc/php/conf.d/app.ini
COPY ./php/frankenphp.conf /etc/frankenphp/conf.d/app.conf


EXPOSE 80
