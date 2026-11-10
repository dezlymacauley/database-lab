/*
    ABOUT: Importing a database into a Postgres cluster
*/
-------------------------------------------------------------------------------

-- SECTION: 1 => How to make a backup of a database

-- TODO:

-------------------------------------------------------------------------------

-- SECTION: 2 => How to use a backup of a database

-- In this example I have the a database backup called:
-- example_database.sql

-- Make sure that this file is in the same directory where you will 
-- be running your `psql` commands.
-------------------------------------------------------------------------------

-- The first step is to login into your Postgres cluster as 
-- the `postgres` user.

-- Using my workflow you can just run this command:

/*

    connect-admin

*/
-------------------------------------------------------------------------------

-- Confirm that the database file is in the same directory where you
-- are running your `psql` commands

-- You can check by using `\!` followed by the `ls` command on Linux / unix
-- systems

/*

\! ls

*/
-------------------------------------------------------------------------------

-- Then create an empty database that will store the contents 
-- of the database file

CREATE DATABASE example_database;
-------------------------------------------------------------------------------

-- Connect to the empty database

/*

\c example_database.sql

*/
-------------------------------------------------------------------------------

-- Import the data from the `.sql` file into the empty database

/*

\i example_database.sql

*/
-------------------------------------------------------------------------------
