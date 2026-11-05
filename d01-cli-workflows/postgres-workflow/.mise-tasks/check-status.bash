#!/usr/bin/env bash
#MISE description="🚥 Check the status of Postgres | alias = check-status"
#MISE quiet=true

#______________________________________________________________________________

# STEP: 1 => Check that the `PGDATA` variable is set

# This line ensures that the script will exit immediately if any commands
# fails or if there are any missing variable
set -euo pipefail

# Checks that the `PGDATA` variable is set
: "${PGDATA:?Missing environment variable PGDATA}"

#______________________________________________________________________________

# STEP: 2 => Check if the Postgres Cluster exists

printf "\n"

if [[ -f "$PGDATA/PG_VERSION" ]]; then
    printf "✅ A Postgres cluster was found at:\n"
    printf "%s\n" "$PGDATA"
else
    printf "⚫ No Postgres cluster was found\n"
fi

#______________________________________________________________________________

# STEP: 3 => Check if the Postgres server is running

printf "\n"

if pg_ctl -D "$PGDATA" status > /dev/null 2>&1; then
    printf "✅ The Postgres server is running\n"
else
    printf "⚫ The Postgres server is not running\n"
fi

printf "\n"
#______________________________________________________________________________
