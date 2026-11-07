/*
    ABOUT: Creating Users and Assigning Roles

    In the previous guide, I created two roles:

    1. `postgres_lab_developer`
    2. `postgres_lab_readonly`

    These roles define what permissions a user should have.

    However, these roles cannot be used to log into PostgreSQL because
    they were created with the `NOLOGIN` attribute.

    In this guide, I will create users that can log into PostgreSQL
    and assign them to the appropriate roles.

    This allows me to manage permissions through roles rather than
    assigning permissions to each user individually.

*/
-------------------------------------------------------------------------------

-- SECTION: 1 => Logging into PostgreSQL as the `postgres` user

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

-- SECTION: 2 => Creating the users

-- I'm going to create two users that will both have permission 
-- to log into Postgres:
-- 1. dezly_macauley
-- 2. kate_kendall

CREATE USER dezly_macauley
LOGIN;

CREATE USER kate_kendall
LOGIN;
-------------------------------------------------------------------------------

-- SECTION: 3 => Add each user to the relevant group

GRANT postgres_lab_developer TO dezly_macauley;
GRANT postgres_lab_readonly TO kate_kendall;

-- The user `dezly_macauley` will have the developer 
-- permissions granted by the
-- `postgres_lab_developer` role

-- The user `kate_kendall` will have only read only permissions.
-------------------------------------------------------------------------------

-- You can use this command to `display roles granted`:

/*
    \drg
*/
-------------------------------------------------------------------------------

-- You should see an output like this:

/*

List of role grants

-[ RECORD 1 ]---------------------
Role name | dezly_macauley
Member of | postgres_lab_developer
Options   | INHERIT, SET
Grantor   | postgres

-[ RECORD 2 ]---------------------
Role name | kate_kendall
Member of | postgres_lab_readonly
Options   | INHERIT, SET
Grantor   | postgres

*/
-------------------------------------------------------------------------------

-- SECTION: 4 => How to revoke a role and delete a user

-- NOTE: I'm going to keep the `kate_kendall` user for future guides
-- This is just an example of how to delete a user.

-- Remove `kate_kendall` from the readonly role.
REVOKE postgres_lab_readonly FROM kate_kendall;

-- Delete the user
DROP USER kate_kendall;
-------------------------------------------------------------------------------
