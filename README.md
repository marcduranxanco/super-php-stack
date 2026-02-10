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

### 0️⃣ Configurar UID y GID

Modificar en el archivo `.env` el **UID y GID del usuario local** que levantará el entorno Docker, para evitar problemas de permisos.

Para obtenerlos:

```bash
id -u && id -g
```

### 1️⃣ Crear `.env.local`

Crear un archivo `.env.local` con las variables específicas del entorno local:

* Nombre del servidor
* Conexión a la base de datos

```env
SERVER_NAME=localhost
DATABASE_URL="postgresql://app:DB_SECRET@database:5432/app?serverVersion=16&charset=utf8"
```

> ⚠️ `.env.local` **no debe versionarse**

### 2️⃣ Construir las imágenes

```bash
docker compose build --no-cache
```

### 3️⃣ Levantar los contenedores

```bash
make up
```

### 4️⃣ Instalar dependencias y preparar el proyecto

Acceder al contenedor PHP:

```bash
make bash
```

Instalar dependencias PHP:

```bash
composer install
```

### 5️⃣ (Opcional) Verificar conexión a la base de datos

```bash
php bin/console dbal:run-sql "SELECT datname FROM pg_database;"
```

Con estos pasos, el entorno queda **listo para desarrollo** y accesible en: <https://localhost>

---

## 📦 Makefile (atajos útiles)

El proyecto incluye un **Makefile** con comandos abreviados para facilitar tareas comunes durante el desarrollo.

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

### OTROS COMANDOS ÚTILES

# Reconstruir imágenes
docker compose build --no-cache

# Entrar al contenedor PHP
docker compose exec php bash

# Limpiar cache
docker compose exec php bin/console cache:clear

# Ver logs
docker compose logs -f php
```


## 🌱 Variables de entorno

* Docker Compose **solo lee variables de los archivos `.env`**
* Verificar si existen variables específicas de Docker en `.env.*`

Archivos relevantes:

* `.env`
  No debe contener variables sensibles ya que está versionado
* `.env.local`
  Uso local, **no versionar**

---

## 🐳 Docker y permisos (UID / GID)

El contenedor PHP se ejecuta usando el **UID/GID del host** para evitar problemas de permisos al editar archivos.

Variables utilizadas:

```env
UID=1001
GID=1001
```

Si se modifican estos valores, es necesario reconstruir la imagen:

```bash
docker compose build --no-cache
```

---

## ▶️ Desarrollo local

### Levantar el entorno

```bash
make up
```

La aplicación estará disponible en: <https://localhost>

---

### Caddyfile usado en desarrollo

En desarrollo se monta:

    .docker/php/caddy_dev.Caddyfile

Este archivo:

*   No usa workers
*   Utiliza la directiva `php_server`
*   Permite recarga automática sin reiniciar contenedores

---

## 🐘 PostgreSQL 17

*   En desarrollo y producción utiliza **volumen Docker** (`database_data`)
*   De manera opcional, en desarrollo puedes usar un bind‑mount

⚠️ Recomendación  
Nunca usar bind-mount de la base de datos en **producción**.

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
