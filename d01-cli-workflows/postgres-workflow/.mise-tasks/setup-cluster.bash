#!/usr/bin/env bash
#MISE description="🐘 Setup the Postgres Cluster | alias = setup-cluster"
#MISE quiet=true

#______________________________________________________________________________

# STEP: 1 => Ensure that the relevant environment variables are set

# This line ensures that the script will exit immediately if any commands
# fails or if there are any missing variable
set -euo pipefail

# These are guard clauses. The script will fail automatically if any of
# these environment variables are missing from `.env`.

# This is a guard clause. The script will fail automatically if any of these
# variables are missing in the `.env` file
: "${PGDATA:?Missing environment variable PGDATA}"
: "${PGHOST:?Missing environment variable PGHOST}"
: "${PGPORT:?Missing environment variable PGPORT}"
: "${PGUSER:?Missing environment variable PGUSER}"
: "${PGDATABASE:?Missing environment variable PGDATABASE}"
#______________________________________________________________________________

# STEP: 2 => Check if there if a Postgres Cluster directory exists

if [[ -e "$PGDATA" ]]; then
    printf "\n"
    printf "🛑 You already have a PGDATA directory at:\n"
    printf "%s\n" "$PGDATA"
    printf "\n"

    read -r -p "Delete the PGDATA directory? [y/n]: " response

    case "$response" in
        [yY]|[yY][eE][sS])
            printf "\n"
            printf "✅ Directory deletion confirmed.\n"
            rm -rf -- "$PGDATA"
            ;;
        *)
            printf "\n"
            printf "❌ Setup cancelled. Existing directory was preserved.\n"
            exit 0
            ;;
    esac
fi

#______________________________________________________________________________

# STEP: 3 => Check if the PGDATA directory contains a valid Postgres Cluster

if [[ -d "$PGDATA" && ! -f "$PGDATA/PG_VERSION" ]]; then
    printf "\n"
    printf "❌ Invalid Postgres cluster at the PGDATA directory\n"
    printf "\n"
    exit 1
fi
#______________________________________________________________________________

# STEP: 4 => Stop the Postgres server if it is running

if pg_ctl -D "$PGDATA" status > /dev/null 2>&1; then
    printf "\n"
    printf "⏳ Stopping the Postgres server...\n"

    # `-m fast` terminates existing connections and rolls back active transactions.
    # `-w` waits until the server has completely stopped.
    pg_ctl -D "$PGDATA" stop -m fast -w > /dev/null

    printf "✅ Postgres server stopped.\n"
else
    printf "\n"
    printf "✅ No Postgres server is running for this cluster.\n"
fi
#______________________________________________________________________________


# Initialize a new Postgres cluster using the login user name.
# `-D` specifies the location of the cluster.
# `-U` specifies the initial database superuser.
# `--auth=trust` enables passwordless authentication.
# printf "\n"
# printf "⏳ Initializing Postgres cluster...\n"
#
# if ! initdb -D "$PGDATA" -U "$PGUSER" --auth=trust > /dev/null; then
#     printf "❌ Failed to initialize Postgres cluster.\n"
#     exit 1
# fi
#
# # Disable checkpoint logging to reduce terminal noise.
# printf "log_checkpoints = off\n" >> "$PGDATA/postgresql.conf"
#
# printf "✅ Postgres cluster initialized.\n"

#______________________________________________________________________________

# STEP: 4 => Create the default database

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
