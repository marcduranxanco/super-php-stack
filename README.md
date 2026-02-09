# Symfony 7.4 + FrankenPHP + Docker

Este proyecto es un **entorno Dockerizado** para trabajar con **Symfony 7.4** usando **FrankenPHP** como servidor de aplicaciones y **PostgreSQL 17** como base de datos.

Está pensado para:

* Desarrollo local cómodo (editar desde el host)
* Rendimiento alto (FrankenPHP en modo worker)
* Poder reutilizar la misma base para **producción**

---

## 🧱 Stack tecnológico

* **Symfony** 7.4
* **PHP** 8.4
* **FrankenPHP** (modo worker)
* **PostgreSQL** 17
* **Docker / Docker Compose**

---

## 📁 Estructura del proyecto

```txt
.
├── .docker/                 # Todo lo relacionado con Docker
│   ├── php/
│   │   ├── Dockerfile
│   │   ├── php.ini
│   │   └── frankenphp.conf
│   └── postgres/
│       └── data/            # Datos PostgreSQL (solo DEV)
├── docker-compose.yml       # Base (dev)
├── docker-compose.prod.yml  # Override producción
├── .env                     # Variables por defecto
├── .env.local               # Variables locales (NO versionadas)
├── .editorconfig
├── public/
├── src/
├── var/
└── README.md
```

---

## 🌱 Variables de entorno

### `.env` (versionado)

Contiene valores por defecto compartidos:

```env
APP_ENV=dev
APP_SECRET=ChangeMe

DATABASE_URL="postgresql://app:secret@postgres:5432/app?serverVersion=17"

SERVER_NAME=localhost
PHP_DATE_TIMEZONE=Europe/Madrid
```

---

### `.env.local` (NO versionado)

> ⚠️ Este archivo **no debe subirse a Git**

Puedes crear uno desde un ejemplo:

```bash
cp .env.local.example .env.local
```

---

## 🐳 Docker y permisos (UID / GID)

El contenedor PHP se ejecuta usando el **UID/GID del host**, para evitar problemas de permisos al editar archivos.

Esto se controla mediante:

```env
UID=1001
GID=1001
```

Si cambias estos valores, debes reconstruir la imagen con `docker compose build --no-cache`

---

## ▶️ Desarrollo local

### 1️⃣ Levantar el entorno

```bash
docker compose up --build
```

La aplicación estará disponible en:

👉 [http://localhost:80](http://localhost:80)

---

### 2️⃣ Instalar dependencias

```bash
docker compose exec php composer install
```

---

### 3️⃣ Crear la base de datos

```bash
docker compose exec php bin/console doctrine:database:create
docker compose exec php bin/console doctrine:migrations:migrate
```

---

### 4️⃣ Trabajar normalmente

* Editas archivos desde el editor local (VSCode, PHPStorm…)
* Los cambios se reflejan al instante
* FrankenPHP corre en **modo worker**

---

## 🐘 PostgreSQL

* Versión: **PostgreSQL 17**
* En desarrollo usa **bind mount**:

  ```
  .docker/postgres/data
  ```

⚠️ **IMPORTANTE**
En producción **NO** se debe usar bind mount para la base de datos.
El `docker-compose.prod.yml` ya está preparado para usar un volumen Docker (`pgdata`).

---

## 🚀 Producción

Este entorno puede reutilizarse para producción usando el override.

```bash
docker compose \
  -f docker-compose.yml \
  -f docker-compose.prod.yml \
  up -d
```

### Diferencias en producción

* `APP_ENV=prod`
* Código montado como `read-only`
* PostgreSQL usa volumen Docker (`pgdata`)
* FrankenPHP sigue en modo worker
* Preparado para añadir HTTPS / reverse proxy

---

## 🧠 FrankenPHP (modo worker)

El proyecto usa FrankenPHP en modo worker:

```env
FRANKENPHP_CONFIG="worker ./public/index.php"
```

⚠️ En desarrollo puede ser necesario reiniciar el contenedor si cambian ciertas configuraciones profundas.

---

## 📂 La carpeta `var/`

`var/` contiene datos en tiempo de ejecución:

* Cache (`var/cache/`)
* Logs (`var/log/`)
* Colas Messenger (`var/messenger/`)
* Sesiones, locks, etc.

👉 **No se debe versionar**

---

## 🧹 `.gitignore`

Archivos importantes que **NO** se suben a Git:

```gitignore
.env.local
.env.*.local
.docker/postgres/data/
var/cache/
var/log/
.idea/
.vscode/
```

---

## 🧰 Comandos útiles

```bash
# 
docker compose build --no-cache

# Entrar al contenedor PHP
docker compose exec php bash

# Limpiar cache
docker compose exec php bin/console cache:clear

# Ver logs
docker compose logs -f php
```