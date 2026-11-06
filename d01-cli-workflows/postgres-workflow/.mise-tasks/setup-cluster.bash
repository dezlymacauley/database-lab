#!/usr/bin/env bash
#MISE description="🐘 Setup the Postgres Cluster | alias = setup-cluster"
#MISE quiet=true

#______________________________________________________________________________

# STEP: 1 => Ensure that the relevant environment variables are set

set -euo pipefail

: "${PGDATA:?Missing environment variable PGDATA}"
: "${PGHOST:?Missing environment variable PGHOST}"
: "${PGPORT:?Missing environment variable PGPORT}"
: "${PGUSER:?Missing environment variable PGUSER}"
: "${PGPASSWORD:?Missing environment variable PGPASSWORD}"
: "${PGDATABASE:?Missing environment variable PGDATABASE}"

#______________________________________________________________________________

# STEP: 2 => Check if there is an existing PGDATA directory

if [[ -e "$PGDATA" ]]; then
    printf "\n"
    printf "🛑 You already have a PGDATA directory at:\n"
    printf "%s\n" "$PGDATA"
    printf "\n"

    read -r -p "Delete the PGDATA directory? [y/n]: " response

    case "$response" in
        [yY]|[yY][eE][sS])
            printf "\n"

            # Stop Postgres if the existing cluster is running.
            if pg_ctl -D "$PGDATA" status > /dev/null 2>&1; then
                printf "⏳ Stopping the Postgres server...\n"

                # `-m fast` terminates existing connections 
                # and rolls back active transactions.
                #
                # `-w` waits until the server has completely stopped.
                pg_ctl -D "$PGDATA" stop -m fast -w > /dev/null
                printf "✅ Postgres server stopped.\n"
            fi

            # Delete the entire PGDATA directory.
            rm -rf -- "$PGDATA"

            printf "✅ PGDATA directory deleted.\n"
            ;;
        *)
            printf "\n"
            printf "❌ Setup cancelled. Existing directory was preserved.\n"
            exit 0
            ;;
    esac
fi
#______________________________________________________________________________

# STEP: 3 => Initialize a new Postgres cluster

printf "\n"
printf "⏳ Initializing Postgres cluster...\n"

# Create a temporary password file with restricted permissions.
umask 077
password_file="$(mktemp)"
trap 'rm -f -- "$password_file"' EXIT

printf '%s\n' "$PGPASSWORD" > "$password_file"

if ! initdb \
    -D "$PGDATA" \
    -U "$PGUSER" \
    --auth=scram-sha-256 \
    --pwfile="$password_file" > /dev/null; then

    printf "❌ Failed to initialize Postgres cluster.\n" >&2
    exit 1
fi

# Disable checkpoint logging to reduce terminal noise.
printf "log_checkpoints = off\n" >> "$PGDATA/postgresql.conf"

printf "✅ Postgres cluster initialized.\n"
#______________________________________________________________________________

# STEP: 4 => Create the database in the Postgres Cluster

# Start the Postgres server with a log file,
# listening on the host and port from the `.env` file.
# printf "\n"
# printf "⏳ Starting Postgres server...\n"
#
# if ! pg_ctl -D "$PGDATA" \
#     -l "$PGDATA/logfile" \
#     -o "-h $PGHOST -p $PGPORT" \
#     -w start > /dev/null; then
#
#     printf "\n"
#     printf "❌ Postgres server failed to start.\n"
#     printf "\n"
#     printf "Postgres startup log:\n"
#
#     if [[ -f "$PGDATA/logfile" ]]; then
#         tail -n 40 "$PGDATA/logfile"
#     fi
#
#     exit 1
# fi
#
# printf "✅ Postgres server started.\n"
#
# # Confirm that Postgres is accepting connections.
# if ! pg_isready -q \
#     -h "$PGHOST" \
#     -p "$PGPORT" \
#     -U "$PGUSER" \
#     -d postgres; then
#
#     printf "❌ Postgres is not accepting connections.\n"
#     exit 1
# fi
#
# printf "✅ Postgres is accepting connections.\n"
#
# # Create the default database.
# printf "\n"
# printf "⏳ Creating default database: %s\n" "$PGDATABASE"
#
# if ! createdb \
#     -h "$PGHOST" \
#     -p "$PGPORT" \
#     -U "$PGUSER" \
#     "$PGDATABASE"; then
#
#     printf "❌ Failed to create database.\n"
#     exit 1
# fi
#
# printf "✅ Default database created.\n"
#
# printf "\n"
# printf "🐘 Postgres cluster setup successful.\n"
# printf "\n"

#______________________________________________________________________________
