#!/usr/bin/env bash
#MISE description="🐘 Setup the Postgres Cluster | alias = setup-cluster"
#MISE quiet=true

#______________________________________________________________________________

# STEP: 1 => Ensure that the environment variables are set

# Enable strict mode for Bash:
# `-euo pipefail` is shorthand for `-e -u -o pipefail`
#
# `-e` means the script should stop immediately if any command returns
# a non-zero exit code.
#
# `-u` means the script should stop immediately if any variables
# are undefined.
#
# `-o pipefail` means the script should stop immediately if any command
# in a pipeline returns a non-zero exit code.
# E.g. If you have (cmd1 | cmd2 | cmd3), if any of those fail then
# the pipeline fails. Normally Bash only looks at the exit code of
# the last command.

set -euo pipefail

# These are guard clauses. The script will fail automatically if any of
# these environment variables are missing from `.env`.
: "${PGDATA:?Missing environment variable PGDATA}"
: "${PGHOST:?Missing environment variable PGHOST}"
: "${PGPORT:?Missing environment variable PGPORT}"
: "${PGUSER:?Missing environment variable PGUSER}"
: "${PGDATABASE:?Missing environment variable PGDATABASE}"

# Restrict trust authentication to local connections.
case "$PGHOST" in
    localhost|127.0.0.1|::1)
        ;;
    *)
        printf "❌ PGHOST must be localhost or a loopback address.\n"
        exit 1
        ;;
esac

#______________________________________________________________________________

# STEP: 2 => Check if there is an existing Postgres Cluster

if [[ -e "$PGDATA" && ! -f "$PGDATA/PG_VERSION" ]]; then
    printf "\n"
    printf "❌ The PGDATA directory exists but is not a valid Postgres cluster.\n"
    printf "📁 Location: %s\n" "$PGDATA"
    printf "\n"
    printf "Aborting to prevent accidental deletion of unrelated files.\n"
    exit 1
fi

if [[ -f "$PGDATA/PG_VERSION" ]]; then
    printf "\n"
    printf "⚠️  An existing Postgres cluster was found.\n"
    printf "📁 Location: %s\n" "$PGDATA"
    printf "\n"
    printf "Deleting this cluster will permanently remove all databases,\n"
    printf "tables, roles and other data stored inside it.\n"
    printf "\n"

    read -r -p "Do you want to delete and recreate this cluster? [y/N]: " response

    case "$response" in
        [yY]|[yY][eE][sS])
            printf "\n"
            printf "✅ Cluster deletion confirmed.\n"
            ;;
        *)
            printf "\n"
            printf "❌ Setup cancelled. Existing cluster was preserved.\n"
            exit 0
            ;;
    esac
fi

#______________________________________________________________________________

# STEP: 3 => Setup the Postgres Database Cluster

# Stop Postgres if it is running.
if [[ -f "$PGDATA/PG_VERSION" ]] && pg_ctl -D "$PGDATA" status > /dev/null 2>&1; then
    printf "\n"
    printf "⏳ Stopping the Postgres server...\n"

    # `-m smart` ensures a graceful shutdown after clients disconnect.
    # `-w` waits until the server has stopped.
    pg_ctl -D "$PGDATA" stop -m smart -w > /dev/null

    printf "✅ Postgres server stopped.\n"
else
    printf "\n"
    printf "✅ No Postgres server is running for this cluster.\n"
fi

# Remove the existing Postgres cluster.
if [[ -f "$PGDATA/PG_VERSION" ]]; then
    rm -rf -- "$PGDATA"
fi

# Initialize a new Postgres cluster using the login user name.
# `-D` specifies the location of the cluster.
# `-U` specifies the initial database superuser.
# `--auth=trust` enables passwordless authentication.
printf "\n"
printf "⏳ Initializing Postgres cluster...\n"

if ! initdb -D "$PGDATA" -U "$PGUSER" --auth=trust > /dev/null; then
    printf "❌ Failed to initialize Postgres cluster.\n"
    exit 1
fi

# Disable checkpoint logging to reduce terminal noise.
printf "log_checkpoints = off\n" >> "$PGDATA/postgresql.conf"

printf "✅ Postgres cluster initialized.\n"

#______________________________________________________________________________

# STEP: 4 => Create the default database

# Start the Postgres server with a log file,
# listening on the host and port from the `.env` file.
printf "\n"
printf "⏳ Starting Postgres server...\n"

if ! pg_ctl -D "$PGDATA" \
    -l "$PGDATA/logfile" \
    -o "-h $PGHOST -p $PGPORT" \
    -w start > /dev/null; then

    printf "\n"
    printf "❌ Postgres server failed to start.\n"
    printf "\n"
    printf "Postgres startup log:\n"

    if [[ -f "$PGDATA/logfile" ]]; then
        tail -n 40 "$PGDATA/logfile"
    fi

    exit 1
fi

printf "✅ Postgres server started.\n"

# Confirm that Postgres is accepting connections.
if ! pg_isready -q \
    -h "$PGHOST" \
    -p "$PGPORT" \
    -U "$PGUSER" \
    -d postgres; then

    printf "❌ Postgres is not accepting connections.\n"
    exit 1
fi

printf "✅ Postgres is accepting connections.\n"

# Create the default database.
printf "\n"
printf "⏳ Creating default database: %s\n" "$PGDATABASE"

if ! createdb \
    -h "$PGHOST" \
    -p "$PGPORT" \
    -U "$PGUSER" \
    "$PGDATABASE"; then

    printf "❌ Failed to create database.\n"
    exit 1
fi

printf "✅ Default database created.\n"

printf "\n"
printf "🐘 Postgres cluster setup successful.\n"
printf "\n"

#______________________________________________________________________________
