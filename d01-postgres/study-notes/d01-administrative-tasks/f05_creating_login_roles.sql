/*
    ABOUT: Creating login-roles

    In the previous guide, I created two non-login roles:

    1. `postgres_lab_developer_group`
    2. `postgres_lab_readonly_group`

    In this guide, I will create two login-roles that can log into Postgres
    and assign them to the relevant permission group.

*/
-------------------------------------------------------------------------------

-- SECTION: 1 => Logging into Postgres as the `postgres` user

-- First, connect to the `postgres` database using the `postgres` user.

-- For my workflow I can do this by running:

/*

    connect-admin

*/
-------------------------------------------------------------------------------

-- Connect to the `postgres_lab` database

/*

    \c postgres_lab

*/
-------------------------------------------------------------------------------

-- SECTION: 2 => Creating the login-roles

CREATE ROLE dezly_macauley
LOGIN;

CREATE ROLE kate_kendall
LOGIN;
-------------------------------------------------------------------------------

-- SECTION: 3 => Add each login-role 
-- to the relevant non-login role (aka permission group)

GRANT postgres_lab_developer_group TO dezly_macauley;

GRANT postgres_lab_readonly_group TO kate_kendall;

-------------------------------------------------------------------------------

-- You can use this command to `display roles granted`:

/*

    \drg

*/
-------------------------------------------------------------------------------

-- You should see an output like this:

/*

   Role name    |          Member of           |   Options    | Grantor
----------------+------------------------------+--------------+----------
 dezly_macauley | postgres_lab_developer_group | INHERIT, SET | postgres
 kate_kendall   | postgres_lab_readonly_group  | INHERIT, SET | postgres

*/
-------------------------------------------------------------------------------

-- To view a list of login-roles, you can use the Postgres's built-in
-- `pg_roles` tables

SELECT rolname
FROM pg_roles
WHERE rolcanlogin;

/*

    rolname
----------------
 postgres
 dezly_macauley
 kate_kendall

*/
-------------------------------------------------------------------------------

-- To view a list of non-login roles use this query

SELECT rolname
FROM pg_roles
WHERE
    NOT rolcanlogin
    AND rolname NOT LIKE 'pg_%';

/*

           rolname
------------------------------
 postgres_lab_developer_group
 postgres_lab_readonly_group
(2 rows)

*/
-------------------------------------------------------------------------------

-- SECTION: 4 => How to remove permissions and delete a role

-- NOTE: I'm going to keep the `kate_kendall` role for future guides
-- This is just an example of how to delete a role.

REVOKE postgres_lab_readonly_group FROM kate_kendall;

DROP ROLE kate_kendall;
-------------------------------------------------------------------------------
