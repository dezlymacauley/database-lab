#!/usr/bin/env bash
#MISE description="🐘 Connect to Postgres for administrative tasks | alias = connect-admin"
#MISE quiet=true
#______________________________________________________________________________

# STEP: 1 => Ensure that a valid Postgres cluster exists and is running

set -euo pipefail

: "${PGDATA:?Missing environment variable PGDATA}"
: "${PGHOST:?Missing environment variable PGHOST}"
: "${PGPORT:?Missing environment variable PGPORT}"
: "${PGPASSWORD:?Missing environment variable PGPASSWORD}"

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

# STEP: 2 => Connect to the Postgres database as the postgres superuser

printf "\n"
printf "⏳ Connecting to Postgres...\n"

exec psql \
    --host="$PGHOST" \
    --port="$PGPORT" \
    --username=postgres \
    --dbname=postgres \
    --no-psqlrc
#______________________________________________________________________________
