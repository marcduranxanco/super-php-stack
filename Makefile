# ------------------------------------------------------------------------------
# Rutas de Compose y .env (Docker)
# ------------------------------------------------------------------------------
COMPOSE_FILES = -f .docker/compose.yml -f .docker/compose.override.yaml
COMPOSE_ENV   = --env-file .docker/.env
COMPOSE       = docker compose $(COMPOSE_FILES) $(COMPOSE_ENV)

# Servicios
PHP_SVC = php
DB_SVC  = database

# Exec helpers
EXEC_PHP = $(COMPOSE) exec --user=www-data $(PHP_SVC)
EXEC_DB  = $(COMPOSE) exec $(DB_SVC)

# ------------------------------------------------------------------------------
# Comandos
# ------------------------------------------------------------------------------

.PHONY: up down ps logs restart build pull
up:
	$(COMPOSE) up -d

stop:
	$(COMPOSE) stop

down:
	$(COMPOSE) down -v

ps:
	$(COMPOSE) ps

logs:
	$(COMPOSE) logs -f

restart:
	$(COMPOSE) down && $(COMPOSE) up -d

build:
	$(COMPOSE) build --no-cache

pull:
	$(COMPOSE) pull


PHONY: init init-env down build up composer_install
# 1) Lanza el script de inicialización (genera .docker/.env y .env.local si faltan)
init-env:
	.docker/scripts/init.sh

# 2) Secuencia completa: primero init-env, luego down → build → up → composer install
init: down build up composer_install
    @echo "✅ Init completado: down → build → up → composer install"

# ------------------------------------------------------------------------------
# Utilidades PHP
# ------------------------------------------------------------------------------
composer_install:
	$(EXEC_PHP) bash -lc 'rm -rf vendor/* var/cache/* || true'
	$(EXEC_PHP) bash -lc 'composer install --no-interaction --prefer-dist'

bash:
	$(EXEC_PHP) bash

cache-clear:
	$(EXEC_PHP) bash -lc 'bin/console cache:clear || (echo "¿Estás dentro del contenedor correcto?"; exit 1)'

# ------------------------------------------------------------------------------
# DB: abrir psql dentro del contenedor de PostgreSQL
# Usa las variables de entorno definidas en el servicio (POSTGRES_USER/POSTGRES_DB).
# ------------------------------------------------------------------------------
db:
	$(EXEC_DB) sh -lc 'psql -U $$POSTGRES_USER -d $$POSTGRES_DB'

# ------------------------------------------------------------------------------
# Tests
# Puedes pasar argumentos adicionales, p.ej.:
#   make test ARGS="--filter ProductTest"
# ------------------------------------------------------------------------------
test:
	$(EXEC_PHP) bash -lc 'if [ -x vendor/bin/phpunit ]; then vendor/bin/phpunit $${ARGS}; elif [ -x bin/phpunit ]; then bin/phpunit $${ARGS}; else echo "PHPUnit no encontrado (vendor/bin/phpunit o bin/phpunit)"; exit 1; fi'
