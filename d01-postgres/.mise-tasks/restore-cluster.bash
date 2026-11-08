#!/usr/bin/env bash
#MISE description="♻️ Restore a Postgres Cluster | alias = restore-cluster"
#MISE quiet=true
#______________________________________________________________________________

# STEP: 1 => Ensure that the relevant environment variables are set

set -euo pipefail

: "${PGDATA:?Missing environment variable PGDATA}"
: "${PGHOST:?Missing environment variable PGHOST}"
: "${PGPORT:?Missing environment variable PGPORT}"
: "${POSTGRES_PASSWORD:?Missing environment variable POSTGRES_PASSWORD}"
#______________________________________________________________________________

# STEP: 2 => Ask for the backup file path

printf "\n"
read -r -p "📂 Enter the path to the Postgres backup (.sql): " backup_file

# Expand $HOME and ${HOME} at the beginning of the path.
case "$backup_file" in
    \$HOME/*)
        backup_file="$HOME/${backup_file#\$HOME/}"
        ;;
    \$\{HOME\}/*)
        backup_file="$HOME/${backup_file#\$\{HOME\}/}"
        ;;
esac

# Validate the backup file extension.
if [[ "$backup_file" != *.sql ]]; then
    printf "❌ The backup file must have a .sql extension.\n" >&2
    exit 1
fi

# Check that the backup file exists and is readable.
if [[ ! -f "$backup_file" || ! -r "$backup_file" ]]; then
    printf "❌ Backup file not found or is not readable:\n" >&2
    printf "%s\n" "$backup_file" >&2
    exit 1
fi

printf "\n"
printf "✅ Backup file found:\n"
printf "%s\n" "$backup_file"
#______________________________________________________________________________

# STEP: 3 => Check if a valid Postgres cluster exists and the server is running

if [[ ! -f "$PGDATA/PG_VERSION" ]]; then
    printf "❌ No valid Postgres cluster was found.\n" >&2
    exit 1
fi

if ! pg_ctl -D "$PGDATA" status > /dev/null 2>&1; then
    printf "❌ The Postgres server is not running.\n" >&2
    exit 1
fi

printf "\n"
printf "✅ Postgres cluster found and server is running.\n"
#______________________________________________________________________________

# STEP: 4 => Confirm the backup restoration

printf "\n"
printf "⚠️ WARNING: This will restore the backup into the current Postgres cluster.\n"
printf "Existing objects may cause conflicts.\n"
printf "A freshly initialized cluster is recommended.\n"
printf "\n"

read -r -p "Restore this backup? [y/n]: " response

case "$response" in
    [yY]|[yY][eE][sS])
        printf "\n"
        printf "⏳ Preparing backup for restoration...\n"
        ;;
    *)
        printf "\n"
        printf "❌ Backup restoration cancelled.\n"
        exit 0
        ;;
esac
#______________________________________________________________________________

# STEP: 5 => Prepare the SQL backup for restoration

# Create a temporary SQL file with restricted permissions.
umask 077
restore_file="$(mktemp)"
trap 'rm -f -- "$restore_file"' EXIT

# Skip CREATE statements for the existing postgres role and database.
# Preserve ALTER statements to restore the original postgres attributes.
awk '
    $0 == "CREATE ROLE postgres;" { next }
    $0 ~ /^CREATE DATABASE postgres([[:space:]]|;)/ { next }
    { print }
' "$backup_file" > "$restore_file"

printf "✅ Backup prepared for restoration.\n"
#______________________________________________________________________________

# STEP: 6 => Restore the Postgres cluster

printf "\n"
printf "⏳ Restoring Postgres cluster backup...\n"

if ! PGPASSWORD="$POSTGRES_PASSWORD" psql \
    --host="$PGHOST" \
    --port="$PGPORT" \
    --username=postgres \
    --dbname=postgres \
    --no-psqlrc \
    --no-password \
    --set=ON_ERROR_STOP=on \
    --file="$restore_file"; then

    printf "\n"
    printf "❌ Postgres cluster restoration failed.\n" >&2
    exit 1
fi

printf "\n"
printf "✅ Postgres cluster backup restored successfully.\n"
#______________________________________________________________________________
