#!/usr/bin/env bash
# .docker/scripts/init.sh
# Inicializa variables locales del proyecto:
#  - Copia .docker/.env.example -> .docker/.env (sin prompts)
#  - Comprueba (y opcionalmente crea) .env.local para Symfony
#
# Uso:
#   .docker/scripts/init.sh                # modo normal
#   .docker/scripts/init.sh --force        # sobrescribe .docker/.env si ya existe
#   .docker/scripts/init.sh --check-only   # solo revisa existencia de archivos
#   .docker/scripts/init.sh --help         # ayuda

set -euo pipefail

# Directorio raíz del repo (sube dos niveles desde este script: .docker/scripts -> repo root)
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

DOCKER_DIR="$ROOT_DIR/.docker"
ENV_EXAMPLE="$DOCKER_DIR/.env.example"
ENV_FILE="$DOCKER_DIR/.env"
APP_ENV_LOCAL="$ROOT_DIR/.env.local"

FORCE=0
CHECK_ONLY=0

print_help() {
  cat <<'EOF'
Inicializa variables de entorno locales.

Opciones:
  -f, --force        Sobrescribe .docker/.env si ya existe
  -c, --check-only   Solo revisa si existen .docker/.env y .env.local
  -h, --help         Muestra esta ayuda
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--force) FORCE=1; shift;;
    -c|--check-only) CHECK_ONLY=1; shift;;
    -h|--help) print_help; exit 0;;
    *) echo "Argumento no reconocido: $1"; print_help; exit 1;;
  esac
done

timestamp() { date +"%Y-%m-%dT%H:%M:%S%z"; }

copy_docker_env() {
  if [[ ! -f "$ENV_EXAMPLE" ]]; then
    echo "⚠️  No existe el archivo de ejemplo: $ENV_EXAMPLE"
    echo "    Crea primero .docker/.env.example"
    return 1
  fi

  if [[ -f "$ENV_FILE" && $FORCE -ne 1 ]]; then
    read -r -p "Ya existe $ENV_FILE. ¿Sobrescribir? (y/N): " ans; ans="${ans:-N}"
    [[ "$ans" =~ ^[Yy]$ ]] || { echo "➡️  Manteniendo $ENV_FILE"; return 0; }
  fi

  cp "$ENV_EXAMPLE" "$ENV_FILE"
  echo "# Generado por .docker/scripts/init.sh el $(timestamp)" >> "$ENV_FILE"
  echo "✅ Copiado $ENV_EXAMPLE -> $ENV_FILE"
  echo "ℹ️  Revisa y ajusta los puertos en $ENV_FILE si es necesario:"
  echo "    - HTTP_PORT (p.ej., 8081)"
  echo "    - HTTPS_PORT (p.ej., 8444)"
  echo "    - DATABASE_PORT (p.ej., 5432)"
}

ensure_env_local() {
  if [[ -f "$APP_ENV_LOCAL" ]]; then
    echo "✔️  $APP_ENV_LOCAL ya existe."
    return 0
  fi

  if [[ $CHECK_ONLY -eq 1 ]]; then
    echo "❗ Falta $APP_ENV_LOCAL (recomendado para overrides locales en Symfony)."
    return 0
  fi

  read -r -p "No existe $APP_ENV_LOCAL. ¿Quieres crearlo ahora? (Y/n): " ans; ans="${ans:-Y}"
  if [[ "$ans" =~ ^[Yy]$ ]]; then
    # APP_SECRET aleatorio (hex 32 chars)
    if command -v openssl >/dev/null 2>&1; then
      secret="$(openssl rand -hex 16)"
    else
      secret="$(LC_ALL=C tr -dc 'a-f0-9' </dev/urandom | head -c 32)"
    fi

    cat > "$APP_ENV_LOCAL" <<EOF
# Local overrides para Symfony
APP_ENV=dev
APP_SECRET=${secret}
SERVER_NAME=localhost
# Ajusta a tu DSN real en local si difiere:
DATABASE_URL="postgresql://app:secret1234@database:5432/app?serverVersion=16&charset=utf8"
# Añade aquí variables locales que NO deban versionarse
EOF
    echo "✅ Creado $APP_ENV_LOCAL"
  else
    echo "➡️  Omitido crear $APP_ENV_LOCAL"
  fi
}

main() {
  mkdir -p "$DOCKER_DIR"

  if [[ $CHECK_ONLY -eq 1 ]]; then
    [[ -f "$ENV_FILE" ]] && echo "✔️  Existe $ENV_FILE" || echo "❗ Falta $ENV_FILE (puedes generarlo desde $ENV_EXAMPLE con .docker/scripts/init.sh)"
    [[ -f "$APP_ENV_LOCAL" ]] && echo "✔️  Existe $APP_ENV_LOCAL" || echo "❗ Falta $APP_ENV_LOCAL (recomendado)"
    exit 0
  fi

  copy_docker_env || true
  ensure_env_local
}

main "$@"
