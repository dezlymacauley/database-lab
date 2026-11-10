/*
    ABOUT: Getting the size of the database

*/

-------------------------------------------------------------------------------

-- Postgres has a built-in function that lets you get the name of 
-- the current database you are using
SELECT current_database();

/*

 current_database
------------------
 postgres_lab

*/
-------------------------------------------------------------------------------

-- Postgres has a built-in function that lets you get the size of a database 
SELECT pg_database_size('postgres_lab');

/*

 pg_database_size
------------------
          7861951
*/
-------------------------------------------------------------------------------

-- You could use the `current_database()` function to get the name

SELECT pg_database_size(current_database());

/*

 pg_database_size
------------------
          7861951
*/
-------------------------------------------------------------------------------

-- Then you can use another built-in function `pg_size_pretty` to make the
-- output easier to read, 
-- and you can use the `AS` keyword to create a custom name for the column
-- in the output.
-------------------------------------------------------------------------------

SELECT pg_size_pretty(pg_database_size(current_database()))
    AS size_of_database;

/*

 size_of_database
------------------
 7678 kB

*/
-------------------------------------------------------------------------------

-- You can add another column that has the name of the current_database

SELECT
    current_database() AS database_name,
    pg_size_pretty(pg_database_size(current_database())) AS database_size;

-------------------------------------------------------------------------------

/*

 database_name | database_size
---------------+---------------
 postgres_lab  | 7678 kB

*/
-------------------------------------------------------------------------------
