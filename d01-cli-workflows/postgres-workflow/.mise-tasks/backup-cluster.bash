#!/usr/bin/env bash
#MISE description="🐘 Backup the Postgres Cluster | alias = backup-cluster"
#MISE quiet=true
#______________________________________________________________________________

# STEP: 1 => Ensure that the relevant environment variables are set

set -euo pipefail

: "${PGDATA:?Missing environment variable PGDATA}"
: "${PGHOST:?Missing environment variable PGHOST}"
: "${PGPORT:?Missing environment variable PGPORT}"
: "${PGPASSWORD:?Missing environment variable PGPASSWORD}"
: "${POSTGRES_BACKUP_DIRECTORY:?Missing environment variable POSTGRES_BACKUP_DIRECTORY}"
#______________________________________________________________________________

# STEP: 2 => Check if a valid Postgres cluster exists and the server is running

if [[ ! -f "$PGDATA/PG_VERSION" ]]; then
    printf "❌ No valid Postgres cluster was found.\n" >&2
    exit 1
fi

if ! pg_ctl -D "$PGDATA" status > /dev/null 2>&1; then
    printf "❌ The Postgres server is not running.\n" >&2
    exit 1
fi

printf "✅ Postgres cluster found and server is running.\n"
#______________________________________________________________________________

# STEP: 3 => Create a backup of the Postgres cluster

printf "\n"
printf "⏳ Creating Postgres cluster backup...\n"

# Create the backup directory if it doesn't exist.
mkdir -p -- "$POSTGRES_BACKUP_DIRECTORY"

# Generate a timestamped backup filename.
backup_file="$POSTGRES_BACKUP_DIRECTORY/postgres-$(date +%Y%m%d-%H%M%S).sql"

# Restrict backup file permissions.
umask 077

if ! pg_dumpall \
    --host="$PGHOST" \
    --port="$PGPORT" \
    --username=postgres \
    --no-password \
    --file="$backup_file"; then

    rm -f -- "$backup_file"

    printf "❌ Failed to create Postgres cluster backup.\n" >&2
    exit 1
fi

printf "✅ Postgres cluster backup created:\n"
printf "%s\n" "$backup_file"
#______________________________________________________________________________
