/*
    ABOUT: Useful psql commands
*/
-------------------------------------------------------------------------------

-- NOTE: Many of the these `psql` commands will also work in `pgcli`

-------------------------------------------------------------------------------

-- \q
-- Quit the psql prompt
-------------------------------------------------------------------------------

-- \x on
-- Turns on `expanded display`
-- The output of any comand you run after this will be displayed as 
-- a vertical column of records.
-------------------------------------------------------------------------------

-- \x off
-- Turns off `expanded display`
-- The output of any comand you run after this will be displayed 
-- as multiple rows.
-------------------------------------------------------------------------------

-- \?
-- List the available commands in psql
-------------------------------------------------------------------------------

-- \l
-- List the databases in the Postgres cluster
-------------------------------------------------------------------------------

-- \c name_of_database
-- Connect to a database
-------------------------------------------------------------------------------

-- \d
-- List the tables in the database that you are currently connected to
-------------------------------------------------------------------------------

-- \d name_of_database
-- List the columns of a specific table
-------------------------------------------------------------------------------
