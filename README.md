# Symfony 7.4 + FrankenPHP + Docker

Este proyecto proporciona un **entorno Dockerizado** para desarrollar aplicaciones con **Symfony 7.4**, utilizando **FrankenPHP** como servidor de aplicaciones y **PostgreSQL 17** como base de datos.

---

## 🧱 Stack tecnológico

* **Symfony** 7.4
* **PHP** 8.4
* **FrankenPHP** (modo worker)
* **PostgreSQL** 17
* **Docker / Docker Compose**

---

## 🌱 Variables de entorno

* Revisar los valores por defecto de las variables de entorno
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
docker compose up --build
```

La aplicación estará disponible en:

👉 [https://localhost](https://localhost)

---

### Instalar dependencias

```bash
docker compose exec php composer install
```

---

## 🐘 PostgreSQL

* Versión: **PostgreSQL 17**
- Por defecto usa un **volumen Docker** (`database_data`)

Opcionalmente, puede usarse un **bind mount** para desarrollo.

⚠️ **Importante**
En producción **no** se debe usar bind mount para la base de datos.

El archivo `docker-compose.prod.yml` ya está preparado para usar un volumen Docker (`pgdata`).

---

## 🚀 Producción

El mismo entorno puede reutilizarse para producción usando un override:

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

⚠️ En desarrollo puede ser necesario reiniciar el contenedor si se cambian configuraciones internas importantes.

---

## 📂 Carpeta `var/`

`var/` contiene datos generados en tiempo de ejecución:

* Cache (`var/cache/`)
* Logs (`var/log/`)
* Colas Messenger (`var/messenger/`)
* Sesiones, locks, etc.

👉 **No se debe versionar**

---

## 🧰 Comandos útiles

```bash
# Reconstruir imágenes
docker compose build --no-cache

# Entrar al contenedor PHP
docker compose exec php bash

# Limpiar cache
docker compose exec php bin/console cache:clear

# Ver logs
docker compose logs -f php
```