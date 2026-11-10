/*

    ABOUT: Customizing the output of the `SELECT` statement

*/

-------------------------------------------------------------------------------

-- NOTE: Remember that unlike `psql` or `pgcli` commands,
-- SQL commands must end with a semicolon `;`

-------------------------------------------------------------------------------

-- A `SELECT` statement will give you an output of what you ask for 
-- as a table.

-- E.g. if you run this:
SELECT 6 + 2;
-------------------------------------------------------------------------------

-- This will be the output 

/*  

?column?
----------
        8
(1 row)

*/
-------------------------------------------------------------------------------

-- Normally the Postgres gets the column name from the table.
-- However this isn't a table so it didn't know what to do.
-------------------------------------------------------------------------------

-- You can customize the output by giving a column a custom name 
-- using the `AS` keyword.

-- This custom name won't affect the data in the database. 
-- Only the output of the SELECT statement is affected.

-- I've customized the column name to `result_of_six_plus_two`
SELECT 6 + 2 AS result_of_six_plus_two;

/*

 result_of_six_plus_two
------------------------
                      8

*/
-------------------------------------------------------------------------------
