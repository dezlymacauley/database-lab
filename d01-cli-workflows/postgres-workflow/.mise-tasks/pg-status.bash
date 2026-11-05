#!/usr/bin/env bash
#MISE description="🚥 View the Postgres server status | alias = pg-status"
#MISE quiet=true

# Check if the Postgres cluster exists
printf "\n"
if [ -f "$PGDATA/PG_VERSION" ]; then
    printf "✅  A Postgres cluster was found\n"
else
    printf "⚫ No Postgres cluster was found\n"
fi

# Check if the Postgres server is running
if pg_ctl status > /dev/null 2>&1; then
    printf "\n✅ The Postgres server is running\n\n"
else
    printf "\n⚫ There is no Postgres server currently running\n\n"
fi
