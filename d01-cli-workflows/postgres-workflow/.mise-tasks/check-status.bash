#!/usr/bin/env bash
#MISE description="🚥 Check the status of Postgres | alias = check-status"
#MISE quiet=true

set -euo pipefail

# Ensure the environment variables are set.
: "${PGDATA:?Missing environment variable PGDATA}"

#______________________________________________________________________________

# Check if the Postgres cluster exists.
printf "\n"

if [[ -f "$PGDATA/PG_VERSION" ]]; then
    printf "✅ A Postgres cluster was found at:\n"
    printf "%s\n" "$PGDATA"
else
    printf "⚫ No Postgres cluster was found\n"
fi

#______________________________________________________________________________

# Check if the Postgres server is running.
if [[ -f "$PGDATA/PG_VERSION" ]] && \
    pg_ctl -D "$PGDATA" status > /dev/null 2>&1; then

    printf "\n"
    printf "✅ The Postgres server is running\n"
else
    printf "\n"
    printf "⚫ There is no Postgres server currently running\n"
fi

printf "\n"
