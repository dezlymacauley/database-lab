#!/usr/bin/env bash
#MISE description="🚥 Check the status of Postgres | alias = check-status"
#MISE quiet=true
#______________________________________________________________________________

# STEP: 1 => Ensure that the relevant environment variables are set

# This line ensures that the script will exit immediately if any commands
# fails or if there are any missing variable
set -euo pipefail

# This is a guard clause. The script will fail automatically if `PGDATA`
# is missing in the `.env` file
: "${PGDATA:?Missing environment variable PGDATA}"
#______________________________________________________________________________

# STEP: 2 => Check if the Postgres Cluster exists

printf "\n"

if [[ ! -f "$PGDATA/PG_VERSION" ]]; then
    printf "⚫ No Postgres cluster was found\n"
    printf "\n"
    exit 0
fi

printf "✅ A Postgres cluster was found at:\n"
printf "%s\n" "$PGDATA"
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
