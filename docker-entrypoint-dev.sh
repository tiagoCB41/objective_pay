#!/bin/bash
set -e

wait_for_postgres() {
  echo "--- Starting Database Setup ---"
  until pg_isready -h postgres -p 5432 -U "$POSTGRES_USER"; do
    echo "Waiting for Postgres..."
    sleep 1
  done
  echo "Postgres is ready. Connection established!"
}

wait_for_postgres



echo "--- Setting up Dev Environment ---"
mix local.hex --force
mix deps.get

echo "Creating database if it does not exist..."
mix ecto.create

echo "Running migrations..."
mix ecto.migrate

echo "--- Starting Phoenix Server ---"
exec mix phx.server