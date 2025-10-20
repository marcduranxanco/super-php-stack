# 🐳 Entorno Docker PHP Base

Este proyecto proporciona un entorno **Dockerizado para PHP** pensado para crear proyectos de prueba, seguir cursos o desarrollar aplicaciones PHP (Symfony, Laravel, etc.) sin depender de las versiones instaladas en tu máquina local.

---

## 🚀 Características

- **PHP-FPM 8.2** (fácilmente intercambiable por otra versión)
- **Nginx** como servidor web
- **MySQL 8.0**
- **Composer** preinstalado

---

## 🧱 Estructura del proyecto

```
php-base/
├── docker-compose.yml
├── php/
│   ├── Dockerfile
│   └── php.ini
├── nginx/
│   ├── default.conf
└── src/
└── index.php
````

---

## ⚙️ Configuración de servicios

### Nginx
- Escucha en el puerto **8087**
- Sirve el contenido desde `src/` (por defecto busca `public/` si existe)
- Configuración en `nginx/default.conf`

### PHP-FPM
- Composer incluido
- Configuración PHP en `php/php.ini`

### MySQL
- Imagen: `mysql:8.0`
- Puertos: `3306:3306`
- Variables:
  - `MYSQL_ROOT_PASSWORD=root`
  - `MYSQL_DATABASE=app`
  - `MYSQL_USER=user`
  - `MYSQL_PASSWORD=secret`
- Volumen persistente: `db_data`

---

## 🧰 Comandos útiles

### 🔹 Iniciar el entorno
```bash
docker compose up -d
````

### 🔹 Detener el entorno

```bash
docker compose down
```

### 🔹 Ver logs

```bash
docker compose logs -f
```

### 🔹 Acceder al contenedor PHP

```bash
docker exec -it php-fpm bash
```

### 🔹 Ejecutar Composer

Dentro del contenedor PHP:

```bash
composer install
composer create-project symfony/skeleton myapp
```

---

## 🧩 Personalización

### Cambiar versión de PHP

En el archivo `php/Dockerfile`:

```Dockerfile
FROM php:8.3-fpm
```

Luego reconstruye la imagen:

```bash
docker compose build php
```

### Cambiar versión de MySQL

En `docker-compose.yml`:

```yaml
image: mysql:5.7
```

---

## 🧪 Probar el entorno

1. Crea un archivo `src/index.php`:

   ```php
   <?php phpinfo(); ?>
   ```

2. Abre [http://localhost:8087](http://localhost:8087)

   Deberías ver la página de información de PHP ✅

---

## 🗂️ Volúmenes y datos persistentes

* El código fuente (`./src`) se monta en tiempo real dentro del contenedor (`/var/www/html`).
* La base de datos se guarda en el volumen `db_data`, así que tus datos no se pierden al reiniciar los contenedores.

---