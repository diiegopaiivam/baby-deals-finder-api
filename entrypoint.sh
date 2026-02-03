#!/usr/bin/env bash
set -euo pipefail

echo "==> Starting Rails container (RAILS_ENV=${RAILS_ENV})"

# Se quiser esperar o banco (útil em docker compose)
if [ -n "${DB_HOST:-}" ]; then
  echo "==> Waiting for DB at ${DB_HOST}:${DB_PORT:-3306}..."
  for i in {1..60}; do
    if (echo > /dev/tcp/${DB_HOST}/${DB_PORT:-3306}) >/dev/null 2>&1; then
      echo "==> DB is reachable."
      break
    fi
    sleep 1
  done
fi

echo "==> Running migrations..."
bundle exec rails db:migrate

echo "==> Booting server..."
exec "$@"
