#!/bin/bash
# docker-entrypoint.sh
set -e

POSTGRES_USER=${POSTGRES_USER:-postgres}
HOST=${DB_HOST:-postgres}

echo "--- Starting Database Setup ---"

until pg_isready -h "$HOST" -p 5432 -U "$POSTGRES_USER"; do
  echo "Postgres is not ready yet, waiting..."
  sleep 1
done
echo "Postgres is ready. Connection established!"

echo "Running migrations..."

/app/objective_pay/bin/objective_pay eval "ObjectivePay.Release.migrate" 

echo "Setup complete. Starting Elixir server..."
exec /app/objective_pay/bin/objective_pay start