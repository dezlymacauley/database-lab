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

-- SECTION: 2 => Creating a developer user

-- Create a user called `postgres_lab_dev`.

-- The LOGIN attribute allows this user to authenticate with PostgreSQL.
CREATE ROLE postgres_lab_dev
LOGIN;
-------------------------------------------------------------------------------
