
# STEP: 3 => Stop the Postgres server if it is running

if [[ -f "$PGDATA/PG_VERSION" ]] && \
    pg_ctl -D "$PGDATA" status > /dev/null 2>&1; then

    printf "\n"
    printf "⏳ Stopping the Postgres server...\n"

    # `-m fast` terminates existing connections and rolls back active transactions.
    # `-w` waits until the server has completely stopped.
    pg_ctl -D "$PGDATA" stop -m fast -w > /dev/null

    printf "✅ Postgres server stopped.\n"
fi
