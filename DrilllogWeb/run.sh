#!/usr/bin/env bash
set -euo pipefail

echo "== DrilllogWeb startup =="

if [[ ! -f ".env" ]]; then
  echo "Missing .env file. Creating from .env.example..."
  cp .env.example .env
  echo "Created .env. Update DB_PASSWORD if needed, then run ./run.sh again."
  exit 1
fi

# Load environment variables from .env
set -a
source .env
set +a

if [[ -z "${DB_USER:-}" || -z "${DB_PASSWORD:-}" ]]; then
  echo "DB_USER or DB_PASSWORD is empty in .env"
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed or not on PATH."
  exit 1
fi

if ! docker ps --format '{{.Names}}' | rg -x "sqlserver" >/dev/null 2>&1; then
  echo "SQL Server container 'sqlserver' is not running."
  echo "Starting it now..."
  docker start sqlserver >/dev/null
fi

echo "Installing dependencies (if needed)..."
npm install --silent

echo "Starting web app at http://localhost:${PORT:-3000}"
echo "DB health endpoint: http://localhost:${PORT:-3000}/health/db"
npm start
