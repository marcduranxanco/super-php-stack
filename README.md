# Symfony 7.4 + FrankenPHP + Docker

Este proyecto proporciona un **entorno Dockerizado** para desarrollar aplicaciones con **Symfony 7.4**, utilizando **FrankenPHP** como servidor de aplicaciones y **PostgreSQL 17** como base de datos.

---

## 🧱 Stack tecnológico

* **Symfony** 7.4
* **PHP** 8.4
* **FrankenPHP**
  *   `php_server` en desarrollo
  *   `worker ./public/index.php` en producción
* **PostgreSQL** 17
* **Docker / Docker Compose**

---

# 🚀 Primera ejecución

### 1 - Generar los archivos `.env`

En la raíz del proyecto ejecuta:

```bash
make init-env
```

Este comando generará:
- `.docker/.env`
- `.env.local`

⚠️ **Importante**: estos archivos NO deben versionarse.

#### Revisar el archivo .docker/.env

Ajusta las variables necesarias.

Es importante indicar el **UID y GID del usuario local**, para evitar problemas de permisos con los archivos generados por Docker.
Puedes obtenerlos así:: `id -u && id -g`

#### Revisar el archivo `.env.local` para Symfony

Ajusta las variables que correspondan. Por ejemplo:
```env
SERVER_NAME=localhost
DATABASE_URL="postgresql://app:DB_SECRET@database:5432/app?serverVersion=16&charset=utf8"
```

### (Opcional) Verificar conexión a la base de datos

```bash
php bin/console dbal:run-sql "SELECT datname FROM pg_database;"
```

Si todo está correcto, el entorno queda listo para desarrollo y accesible en: <https://localhost> (o el puerto HTTPS que hayas configurado).

---

## ▶️ Desarrollo local

### Levantar el entorno

```bash
make up
```

La aplicación estará disponible en:  <https://localhost> (o el puerto HTTPS que hayas configurado).

---

## 📦 Makefile (atajos útiles)

El proyecto incluye un **Makefile**  con comandos abreviados para facilitar el desarrollo.

### Comandos disponibles

```bash
# Abrir bash dentro del contenedor PHP (como www-data)
make bash

# Levantar el entorno en segundo plano
make up

# Reiniciar servicios
make restart

# Detener servicios
make stop

# Ver logs de todos los contenedores
make logs

# Limpiar la caché de Symfony
make cache-clear

# Entrar en la base de datos PostgreSQL con psql
make db

# Ejecutar la suite de tests (PHPUnit)
make test
# Ejemplo filtrando un test concreto:
make test ARGS="--filter ProductTest"
```

---

## 🐳 Docker y permisos (UID / GID)

El contenedor PHP se ejecuta usando el **UID/GID del host** para evitar problemas de permisos al editar archivos.

Las variables se setean en `.docker/.env`:
```env
UID=1001
GID=1001
```

Si se modifican estos valores, es necesario reconstruir la imagen (`make build`).

---

### Caddyfile usado en desarrollo

En desarrollo se monta:

    .docker/php/caddy_dev.Caddyfile

Este archivo:

*   Utiliza la directiva `php_server`
*   Permite recarga automática sin reiniciar contenedores

---

## 🐘 PostgreSQL 17

*   En desarrollo y producción utiliza **volumen Docker** (`database_data`)
*   De manera opcional, en desarrollo puedes usar un bind‑mount

⚠️ Nunca usar bind-mount de la base de datos en **producción**.

---

## 🚀 Producción

El mismo entorno puede reutilizarse para producción usando un override:

```bash
docker compose \
  -f compose.yml \
  -f compose.prod.yaml \
  up -d
```

### Diferencias en producción

* `APP_ENV=prod`
* Código montado como `read-only`
* PostgreSQL usa volumen Docker (`pgdata`)
* FrankenPHP sigue en modo worker
* Preparado para añadir HTTPS / reverse proxy

### Caddyfile en producción

En producción se monta automáticamente:

    .docker/php/caddy_prod.Caddyfile

Contiene la configuración del worker:

```caddy
frankenphp {
    worker ./public/index.php
}
```

---

## 🧠 FrankenPHP

### En desarrollo

*   Modo: **php\_server**
*   No usa worker
*   No cachea contenedor ni routing
*   Refleja cambios al instante
*   No son necesarios reinicios del contenedor

### En producción

*   Modo worker: **worker ./public/index.php**
*   La aplicación permanece cargada en memoria
*   Requiere reinicio de contenedor tras cambios estructurales (normal en prod)

---

## 📂 Carpeta `var/`

`var/` contiene datos generados en tiempo de ejecución:

* Cache (`var/cache/`)
* Logs (`var/log/`)
* Colas Messenger (`var/messenger/`)
* Sesiones, locks, etc.

👉 **No se debe versionar**

---
