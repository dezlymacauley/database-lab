/*
    ABOUT: Managing passwords
*/
-------------------------------------------------------------------------------

-- Every Postgres Cluster has a system table called `pg_authid`.
-- It stores information about all PostgreSQL roles.
-- The `pg_authid` table contains many roles and columns.

-------------------------------------------------------------------------------

-- SECTION: 1 => The `pg_authid` table

-- You can view a list of the columns in the `pg_authid` table 
-- with this command:

/*
    postgres_lab=# \d pg_authid
*/
-------------------------------------------------------------------------------

-- You should see an output like this:

/*

                        Table "pg_catalog.pg_authid"
     Column     |           Type           | Collation | Nullable | Default
----------------+--------------------------+-----------+----------+---------
 oid            | oid                      |           | not null |
 rolname        | name                     |           | not null |
 rolsuper       | boolean                  |           | not null |
 rolinherit     | boolean                  |           | not null |
 rolcreaterole  | boolean                  |           | not null |
 rolcreatedb    | boolean                  |           | not null |
 rolcanlogin    | boolean                  |           | not null |
 rolreplication | boolean                  |           | not null |
 rolbypassrls   | boolean                  |           | not null |
 rolconnlimit   | integer                  |           | not null |
 rolpassword    | text                     | C         |          |
 rolvaliduntil  | timestamp with time zone |           |          |
Indexes:
    "pg_authid_oid_index" PRIMARY KEY, btree (oid), tablespace "pg_global"
    "pg_authid_rolname_index" UNIQUE CONSTRAINT, btree (rolname), 
    tablespace "pg_global"
Tablespace: "pg_global"

*/
-------------------------------------------------------------------------------

-- You can view the rows of a table by using SQL.
-- To be more specific, a `SELECT` statement.
-------------------------------------------------------------------------------

-- The basic syntax is:
-- SELECT column_name FROM table_name;
-------------------------------------------------------------------------------

-- SECTION: 2 => Checking which roles with roles login permission

-- This means:
-- Show me the rows from the `rolname` column and the `rolcanlogin` column
-- from the `pg_authid` table,

-- But only include results where roles where `rolcanlogin` is TRUE.
-- In otherwords, only show roles that have the ability to log into Postgres.

-- Then order the results alphabetically based on the values
-- in the `rolname` column.
SELECT
    rolname,
    rolcanlogin
FROM pg_authid
WHERE rolcanlogin = TRUE
ORDER BY rolname;
-------------------------------------------------------------------------------

-- SECTION: 2 => Checking which roles do not have a password set 

/*

SELECT
    rolname,
    rolcanlogin,
    rolpassword
FROM pg_authid
WHERE
    rolcanlogin = TRUE
    AND rolpassword IS NULL
ORDER BY rolname;

*/

-------------------------------------------------------------------------------

-- This shows that the users `dezly_macauley` and `kate_kendall` do
-- not have passwords set.

/*

ORDER BY rolname;
    rolname     | rolcanlogin | rolpassword
----------------+-------------+-------------
 dezly_macauley | t           |
 kate_kendall   | t           |
(2 rows)

*/
-------------------------------------------------------------------------------

-- SECTION: 3 => How to set the passwords 

/*

\password dezly_macauley

*/
-------------------------------------------------------------------------------

-- Remember to do the set a password for `kate_kendall` as well
-------------------------------------------------------------------------------

-- If I run the SELECT query again, 
-- you should see that ther are no login roles that no not have a password

/*

ORDER BY rolname;
 rolname | rolcanlogin | rolpassword
---------+-------------+-------------
(0 rows)

*/
-------------------------------------------------------------------------------
