# 🐳 Entorno Docker PHP Base

Este proyecto proporciona un entorno **Dockerizado para PHP** pensado para crear proyectos de prueba, seguir cursos o desarrollar aplicaciones PHP (Symfony, Laravel, etc.) sin depender de las versiones instaladas en tu máquina local.

### 🧱 Crear un nuevo proyecto desde esta base

Para iniciar un proyecto nuevo sin modificar este repositorio:

1. Clona el repositorio y elimina el historial de Git:

   ```bash
   git clone --depth=1 https://github.com/marcduranxanco/super-php-stack.git nombre-del-proyecto
   cd nombre-del-proyecto
   rm -rf .git
   ```

2. Inicializa un nuevo repositorio:

   ```bash
   git init
   git remote add origin https://github.com/tu-usuario/nuevo-repo.git
   git add .
   git commit -m "Initial commit from super-php-stack base"
   git push -u origin main
   ```

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

### 🛠️ Problemas de permisos en entorno local

El contenedor PHP usa un usuario genérico (appuser) con UID/GID personalizados para evitar problemas de permisos al compartir archivos con el sistema local. Esto permite editar los archivos generados dentro del contenedor desde tu máquina sin restricciones.

Si no puedes editar los archivos generados dentro del contenedor desde tu máquina local, puede que el UID/GID del usuario del contenedor no coincida con el tuyo.

#### ✅ Solución

Modifica estas líneas en el `Dockerfile`:

```dockerfile
ARG USER_ID=1001
ARG GROUP_ID=1001
RUN groupadd -g ${GROUP_ID} appgroup \
    && useradd -u ${USER_ID} -g ${GROUP_ID} -m appuser

USER appuser
```

Obtén tu UID y GID local con:

```bash
id -u && id -g
```

Y reconstruye la imagen con:
```bash
docker-compose build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) --no-cache
```

---


<p align="center">
  <a href="https://laravel.com" target="_blank">
    <img src="https://laravel.com/img/logomark.min.svg" width="100" alt="Laravel Logo">
  </a>
</p>

# Crear un nuevo proyecto Laravel desde cero


1. **Accede al contenedor PHP:**

   ```bash
   docker exec -it php-fpm bash
   ```

2. **Ve a la carpeta donde está montado tu código:**

   ```bash
   cd /var/www/html
   ```

3. **Crea un nuevo proyecto Laravel:**

   ```bash
   composer create-project laravel/laravel .
   ```

   > El `.` al final indica que se instalará en la carpeta actual (`/var/www/html` → tu carpeta `src/` local).

4. **Cambia permisos (si usas Linux o Docker con usuario distinto):**

   ```bash
   chown -R www-data:www-data storage bootstrap/cache
   chmod -R 775 storage bootstrap/cache
   ```

5. **Sal del contenedor:**

   ```bash
   exit
   ```

6. **Accede a Laravel desde tu navegador:**
   [http://localhost:8087](http://localhost:8087) ✅

---

## 🧩 Configurar `.env` para la base de datos

En el archivo `src/.env`, ajusta las variables para usar el contenedor MySQL de tu `docker-compose`:

```env
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=app
DB_USERNAME=user
DB_PASSWORD=secret
```

Luego ejecuta las migraciones dentro del contenedor PHP:

```bash
docker exec -it php-fpm php artisan migrate
```

---

## 🧰 Comandos útiles dentro del contenedor

* Ejecutar Artisan:

  ```bash
  docker exec -it php-fpm php artisan serve
  ```

  *(no necesario si ya usas Nginx)*

* Instalar dependencias adicionales:

  ```bash
  docker exec -it php-fpm composer require laravel/breeze
  ```

* Ejecutar migraciones:

  ```bash
  docker exec -it php-fpm php artisan migrate
  ```

