# VARS
EXEC_PHP=docker compose exec --user=www-data php
EXEC_DB  = docker compose exec database

# ------------------------------------------------------------------------------

bash:
	$(EXEC_PHP) bash

up:
	docker compose up -d

restart:
	docker compose restart

stop:
	docker compose stop

logs:
	docker compose logs -f

cache-clear:
	$(EXEC_PHP) bin/console cache:clear

# DB: abrir psql dentro del contenedor de PostgreSQL
# Usa las variables de entorno definidas en el servicio (POSTGRES_USER/POSTGRES_DB).
# Si no están definidas, puedes exportarlas antes de ejecutar make, p.ej.:
#   POSTGRES_USER=app POSTGRES_DB=app_db make db
db:
	$(EXEC_DB) bash -lc 'psql -U "$${POSTGRES_USER:-postgres}" -d "$${POSTGRES_DB:-postgres}"'

# Tests: ejecutar PHPUnit dentro del contenedor PHP como www-data
# Si tu proyecto usa ./vendor/bin/phpunit (lo habitual en Symfony), esto funcionará.
# Puedes pasar argumentos adicionales, p.ej.:
#   make test ARGS="--filter ProductTest"
test:
	$(EXEC_PHP) bash -lc 'if [ -x vendor/bin/phpunit ]; then vendor/bin/phpunit $${ARGS}; elif [ -x bin/phpunit ]; then bin/phpunit $${ARGS}; else echo "PHPUnit no encontrado (vendor/bin/phpunit o bin/phpunit)"; exit 1; fi'