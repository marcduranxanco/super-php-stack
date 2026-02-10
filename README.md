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

👉 <https://localhost>

---

### Instalar dependencias

```bash
docker compose exec php composer install
```

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
Nunca uses bind-mount de la base de datos en **producción**.

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