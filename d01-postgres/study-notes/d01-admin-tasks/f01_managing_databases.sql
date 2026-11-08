/*
    ABOUT: Managing Databases

    In this guide I'll be creating a database called `postgres_lab`
*/
-------------------------------------------------------------------------------

-- SECTION: 1 => Connecting to the `postgres` database 

-- Use `psql` to log in to the `postgres` database
-- using the `postgres` user.

-- For my workflow I can do this by running this command:

/*

    connect-admin  

*/
-------------------------------------------------------------------------------

-- You will be logged into a prompt that looks like this

/*

⏳ Connecting to Postgres...
psql (18.6)
Type "help" for help.

postgres=#

*/
-------------------------------------------------------------------------------

-- Press `Ctrl l` to clear the terminal output
-- You terminal should look like this now

/*

postgres=#

*/
-------------------------------------------------------------------------------

-- SECTION: 2 => Viewing the databases in your Postgres Cluster

-- A PostgreSQL cluster is a collection of databases.

-- PostgreSQL uses a client-server model.

-- A PostgreSQL server is a continuously running program
-- that allows clients to connect to its databases.

-- Database clients are programs like `psql` and `pgcli`
-- that allow you to interact with a PostgreSQL server.

-------------------------------------------------------------------------------

-- You are now logged into the database called `postgres`
-- using the user called `postgres`

-- To list the databases in the Postgres cluster,
-- run this commmand:

/*

\l

*/
-------------------------------------------------------------------------------

-- NOTE: This command is a `psql` commmand and not a SQL command

-- That's why it starts with a backslash `\` 
-- and does not end with a semicolon
-------------------------------------------------------------------------------

-- SECTION: 3 => Making the terminal output easier to read

-- The default behavior of `psql` is to display the output as horizontal rows.

-- you can tell `psql` to display the output as vertical columns by running
-- this command to turn explanded display on

/*

\x on

*/
-------------------------------------------------------------------------------

-- Then run this command again:

/*

\l

*/
-------------------------------------------------------------------------------

-- Press the `Enter` key to scroll down
-- Press `q` to return to your prompt
-- And you can press `Ctrl l` to clear the terminal output
-------------------------------------------------------------------------------

-- You should see these 3 databases if you are working with 
-- a new Postgres cluster

-- NOTE: Do not delete these three databases

-- 1. postgres
-- 2. template0
-- 3. template1
-------------------------------------------------------------------------------

-- The `postgres` database is what you log into when performing admin tasks 
-- on the Postgres cluster.

-- The other two databases, `template0` and `template1`, 
-- are used by Postgres as templates when you want to add 
-- a new database to the Postgres cluster.
-------------------------------------------------------------------------------

-- To turn off expandend display, run this command

/*

\x off

*/
-------------------------------------------------------------------------------

-- SECTION: 4 => How to check what user and database you are connected to 


/*

\conninfo

*/
-------------------------------------------------------------------------------

-- You'll get an output like this

/*

      Connection Information
      Parameter       |   Value
----------------------+-----------
 Database             | postgres
 Client User          | postgres
 Host                 | 127.0.0.1
 Server Port          | 5432
 Options              |
 Protocol Version     | 3.0
 Password Used        | true
 GSSAPI Authenticated | false
 Backend PID          | 69374
 SSL Connection       | false
 Superuser            | on
 Hot Standby          | off
(12 rows)

*/
-------------------------------------------------------------------------------

-- SECTION: 4 => Creating the database 

-- Run this SQL command to create a database called `postgres_lab`
CREATE DATABASE postgres_lab;
-------------------------------------------------------------------------------

-- To connect to the `postgres_lab` run this command: 

/*

\c postgres_lab 

*/
-------------------------------------------------------------------------------

-- You prompt will now look like this

/*

postgres_lab=#

*/
-------------------------------------------------------------------------------

-- SECTION: 5 => Deleting a database 

-- You can't delete the `postgres_lab` database because you are currently 
-- connected to it.

-- First connect to the `postgres` database by running this command

/*

\c postgres

*/
-------------------------------------------------------------------------------

-- Your prompt should look like this:

/*

postgres=#

*/
-------------------------------------------------------------------------------

-- Then run this command:
DROP DATABASE postgres_lab;
-------------------------------------------------------------------------------

-- To exit the prompt, run this command: \q
-------------------------------------------------------------------------------
