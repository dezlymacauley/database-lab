/*
    ABOUT: Managing backups
*/
-------------------------------------------------------------------------------

-- This guide is specific to my workflow
-------------------------------------------------------------------------------

-- SECTION: 1 => Backing up a cluster

-- To make a backup of the Postgres cluster I run this command: 
-- backup-cluster
-------------------------------------------------------------------------------

-- SECTION: 2 => Restoring a cluster from a `.sql` backup file

-- I make a copy of the backup, rename it to `backup.sql` 
-- and move it to the same directory 
-- where I run the `restore-cluster` command later in this guide.
-------------------------------------------------------------------------------

-- First I run this command to shutdown the Postgres server: 
-- toggle-server`

-------------------------------------------------------------------------------

-- Next I run `check-status` to ensure that the server has been shutdown.
-------------------------------------------------------------------------------

-- Then I delete the current Postgres cluster (The one I've backed up)
-------------------------------------------------------------------------------

-- I then run `setup-cluster` to create a new Postgres cluster
-- and start the `Postgres server`
-------------------------------------------------------------------------------

-- Then run: restore-cluster

-------------------------------------------------------------------------------

-- When this prompt appears, I just type this and press enter: 
-- backup.sql

/*

📂 Enter the path to the Postgres backup (.sql):

*/
-------------------------------------------------------------------------------

-- The prompt changes to this, and I type `y` and press enter

/*

✅ Backup file found:
backup.sql

✅ Postgres cluster found and server is running.

⚠ Warning: This will restore the backup into the current Postgres cluster.
Existing objects may cause conflicts.
A freshly initialized cluster is recommended.

Restore this backup? [y/n]:

*/
-------------------------------------------------------------------------------

-- You should see this if everything goes well

/*

✅ Postgres cluster backup restored successfully.

*/
-------------------------------------------------------------------------------

-- Finally I delete the `backup.sql` file
-------------------------------------------------------------------------------
