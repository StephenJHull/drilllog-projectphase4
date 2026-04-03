#!/usr/bin/env bash
set -euo pipefail

# One-command DB reset for local Docker SQL Server.
# Usage:
#   ./reset_db.sh
#   SA_PASSWORD='YourStrong!Pass123' ./reset_db.sh
#   DB_NAME='DrilllogDB' CONTAINER_NAME='sqlserver' ./reset_db.sh

CONTAINER_NAME="${CONTAINER_NAME:-sqlserver}"
DB_NAME="${DB_NAME:-DrilllogDB}"
SQL_USER="${SQL_USER:-sa}"
SA_PASSWORD="${SA_PASSWORD:-YourStrong!Pass123}"
CONTAINER_WORKDIR="${CONTAINER_WORKDIR:-/tmp/drilllog-work}"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required but not found."
  exit 1
fi

if ! docker ps --format '{{.Names}}' | rg -x "$CONTAINER_NAME" >/dev/null 2>&1; then
  echo "Container '$CONTAINER_NAME' is not running. Starting..."
  docker start "$CONTAINER_NAME" >/dev/null
fi

SQLCMD_PATH="/opt/mssql-tools18/bin/sqlcmd"
if ! docker exec "$CONTAINER_NAME" test -x "$SQLCMD_PATH"; then
  SQLCMD_PATH="/opt/mssql-tools/bin/sqlcmd"
fi

if ! docker exec "$CONTAINER_NAME" test -x "$SQLCMD_PATH"; then
  echo "Could not find sqlcmd inside container."
  exit 1
fi

run_sql_file() {
  local file_path="$1"
  echo "Running: $file_path"
  docker exec -i "$CONTAINER_NAME" "$SQLCMD_PATH" \
    -S localhost -U "$SQL_USER" -P "$SA_PASSWORD" -C \
    -d "$DB_NAME" -i "$CONTAINER_WORKDIR/$file_path"
}

echo "Resetting database '$DB_NAME'..."
docker exec -i "$CONTAINER_NAME" "$SQLCMD_PATH" \
  -S localhost -U "$SQL_USER" -P "$SA_PASSWORD" -C -d master \
  -Q "IF DB_ID(N'$DB_NAME') IS NOT NULL BEGIN ALTER DATABASE [$DB_NAME] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [$DB_NAME]; END; CREATE DATABASE [$DB_NAME];"

echo "Copying repository into container temp path..."
docker exec "$CONTAINER_NAME" rm -rf "$CONTAINER_WORKDIR"
docker exec "$CONTAINER_NAME" mkdir -p "$CONTAINER_WORKDIR"
docker cp . "$CONTAINER_NAME":"$CONTAINER_WORKDIR"

# Tables first
run_sql_file "Database/Tables/Quarry.sql"
run_sql_file "Database/Tables/Employee.sql"
run_sql_file "Database/Tables/Drill.sql"
run_sql_file "Database/Tables/DrillLog.sql"
run_sql_file "Database/Tables/DrillPattern.sql"
run_sql_file "Database/Tables/DrillHole.sql"
run_sql_file "Database/Tables/Drilling.sql"

# Foreign keys next
run_sql_file "Database/Tables/ForeignKeys/FK_DrillLog_Quarry.sql"
run_sql_file "Database/Tables/ForeignKeys/FK_DrillLog_Employee.sql"
run_sql_file "Database/Tables/ForeignKeys/FK_DrillHole_DrillLog.sql"
run_sql_file "Database/Tables/ForeignKeys/FK_DrillHole_Drill.sql"

echo "Done. Database '$DB_NAME' recreated and schema applied."
