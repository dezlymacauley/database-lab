/*
    ABOUT: Using roles as membership groups

    In Postgres a role a named collection of rules

    The user `postgres` is meant for administrative tasks.
    It should not be used for interacting with databases,
    even though it has the ability to do so.

    It's better to create additional users that will be used for interacting
    with the databases.

    However, before creating additional users,
    it's best practice to do the following:

    1. Create `roles` that define access rules.
    2. Then create `users`.
    3. Then attach a role to a `user` based on what that user needs to do.
    ___________________________________________________________________________

    The whole point of a `role` is that it allows you to manage the permissions
    of multiple users using one central mechanism, rather than assigning
    permissions to each individual user you create.
    ___________________________________________________________________________

    In this guide I will create two `roles` for interacting with
    the `postgres_lab` database:

    1. `postgres_lab_developer`
    2. `postgres_lab_readonly`
    ___________________________________________________________________________

    1. `postgres_lab_developer`

    Members of this role can perform CRUD operations and manage
    database objects.

    They will be able to create and manage tables, indexes, sequences,
    types, views and other objects within the `app` schema.
    ___________________________________________________________________________

    2. `postgres_lab_readonly`

    Members of this role are only allowed to read the contents
    of the database.

    They will be able to query tables and views within the `app` schema,
    but will not be able to modify the data or manage database objects.
    ___________________________________________________________________________
*/

-------------------------------------------------------------------------------

-- SECTION: 1 => Login to the `postgres` database as the `postgres` user

-- For my workflow I just run this command

/*
    connect-admin
*/
-------------------------------------------------------------------------------

-- Login to the `postgres_lab` database

/*
    \c postgres_lab
*/
-------------------------------------------------------------------------------

-- SECTION: 2 => Understanding role permissions

-- NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS;

-- Here's what the line above means:

-- NOLOGIN 
-- I don't want the `postgres_lab_developer` role on its own to be used as
-- a way to login to the `postgres_lab` database without a user.
-- I'm using the `postgres_lab_developer` role as collection of rules
-- (think of it as a membership group) that users can be part of.
-- Then a user that is a member of `postgres_lab_developer` will be able to
-- log into the database.

-- NOSUPERUSER
-- A member of the `postgres_lab_developer` role cannot have 
-- unrestricted administrator privileges.
-- A superuser has full access to perform all kinds of actions 
-- on databases in the Postgres. E.g. the user called `Postgres` is an
-- example of a superuser.

-- NOCREATEDB
-- This role cannot create new databases.

-- NOCREATEROLE
-- This role cannot create or manage other PostgreSQL roles.
-- Remember: PostgreSQL users are also roles.

-- NOREPLICATION
-- This role cannot perform special PostgreSQL replication operations.
-- Replication is used to copy and synchronise data between servers.

-- This role cannot bypass Row-Level Security (RLS).
-- RLS allows PostgreSQL to restrict which rows a user can access.
-- E.g. A company could use RLS to ensure that employees only see records 
-- that belong to their department.
-------------------------------------------------------------------------------

-- SECTION: 3 => Creating the roles

-- The naming convention I follow when creating a role is:
-- database_name_the_type_of_actions

CREATE ROLE postgres_lab_developer
NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS;

CREATE ROLE postgres_lab_readonly
NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS;
-------------------------------------------------------------------------------

-- SECTION: 4 => Viewing the `roles` of a Postgres Cluster

/*

\x on

\du+

*/
-------------------------------------------------------------------------------

-- You should see this

/*

List of roles
-[ RECORD 1 ]-----------------------------------------------------------
Role name   | postgres
Attributes  | Superuser, Create role, Create DB, Replication, Bypass RLS
Description |
-[ RECORD 2 ]-----------------------------------------------------------
Role name   | postgres_lab_developer
Attributes  | Cannot login
Description |
-[ RECORD 3 ]-----------------------------------------------------------
Role name   | postgres_lab_readonly
Attributes  | Cannot login
Description |

*/
-------------------------------------------------------------------------------

-- SECTION: 5 => Specify what databases a member of the role should 
-- be allowed to connect to

-- Allow the developer role to connect to postgres_lab.
GRANT CONNECT ON DATABASE postgres_lab
TO postgres_lab_developer;

-- Allow the readonly role to connect to postgres_lab.
GRANT CONNECT ON DATABASE postgres_lab
TO postgres_lab_readonly;
-------------------------------------------------------------------------------

-- SECTION: 6 => Specify what schemas a member of the role should
-- be allowed to access

-- Allow the developer role to access and create objects inside `study_notes`.
GRANT USAGE, CREATE ON SCHEMA study_notes
TO postgres_lab_developer;

-- Allow the readonly role to access objects inside `study_notes`.
GRANT USAGE ON SCHEMA study_notes
TO postgres_lab_readonly;
-------------------------------------------------------------------------------

-- SECTION: 7 => Specify what table operations a member of the role should
-- be allowed to perform on existing tables

-- Allow the developer role to perform CRUD operations on all existing tables
-- inside the `study_notes` schema.
GRANT INSERT, SELECT, UPDATE, DELETE ON ALL TABLES IN SCHEMA study_notes
TO postgres_lab_developer;

-- Allow the readonly role to read all existing tables
-- inside the `study_notes` schema.
GRANT SELECT ON ALL TABLES IN SCHEMA study_notes
TO postgres_lab_readonly;
-------------------------------------------------------------------------------

-- NOTE: A role does not have the ability to grant a user permission to log
-- into Postgres. That is something that you set at an individual level when
-- you create the user.
-------------------------------------------------------------------------------
