/*
    ABOUT: Getting the size of the database

*/

-------------------------------------------------------------------------------

-- NOTE: This SQL query is specific to Postges databases

SELECT
    current_database() AS database_name,
    pg_size_pretty(pg_database_size(current_database())) AS total_size;

-------------------------------------------------------------------------------

/*  

 database_name | total_size
---------------+------------
 postgres_lab  | 7678 kB

*/
-------------------------------------------------------------------------------
