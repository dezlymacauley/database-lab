/*
    ABOUT: Backing up a Postgres Cluster

*/

-------------------------------------------------------------------------------

-- STEP: 1 => Make sure the Postgres server is currently running

-------------------------------------------------------------------------------

-- STEP: 2 => Create a backup of the Postgres cluster

-- My workflow contains a command called `backup-cluster` that will create
-- a timestamped backup of the Postgres Cluster that looks like this:
-- postgres-20261108-064703.sql
-------------------------------------------------------------------------------

-- STEP: 3 => Shutdown the Postgres server 

-------------------------------------------------------------------------------

-- STEP: 4 => Delete the Postgres cluster

-------------------------------------------------------------------------------

-- STEP: 5 => Setup a new Postgres cluster

-- My workflow has a command for this:
-- setup-cluster

-------------------------------------------------------------------------------

-- STEP: 6 => Ensure that the Postgres server is running

-- My workflow has a command for this:
-- check-status

-- And if the the server is not running:
-- toggle-status

-------------------------------------------------------------------------------

-- STEP: 7 => Restore the backup

-- TODO: Consider creating a restore-backup command

/*

PGPASSWORD="$POSTGRES_PASSWORD" psql \
    --host="$PGHOST" \
    --port="$PGPORT" \
    --username=postgres \
    --dbname=postgres \
    --no-password \
    --set ON_ERROR_STOP=on \
    --file="$HOME/local-workspace/postgres-database-backups/postgres-20261108-064703.sql"

*/
-------------------------------------------------------------------------------
