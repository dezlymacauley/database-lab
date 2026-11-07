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

-- SECTION: 3 => Viewing the `roles` of a Postgres Cluster

/*

\x on

\du

*/
-------------------------------------------------------------------------------

-- You should see this

/*

List of roles
-[ RECORD 1 ]----------------------------------------------------------
Role name  | postgres
Attributes | Superuser, Create role, Create DB, Replication, Bypass RLS
-[ RECORD 2 ]----------------------------------------------------------
Role name  | postgres_lab_developer
Attributes | Cannot login
-[ RECORD 3 ]----------------------------------------------------------
Role name  | postgres_lab_readonly
Attributes | Cannot login

*/
-------------------------------------------------------------------------------




-- SECTION: 3 => Configure database access

-- PostgreSQL grants CONNECT, CREATE and TEMPORARY privileges to PUBLIC
-- by default. Revoke those privileges on postgres_lab so access can
-- be managed explicitly through permission roles.

REVOKE ALL ON DATABASE postgres_lab
FROM public;

-- Allow both roles to connect to postgres_lab.

GRANT CONNECT ON DATABASE postgres_lab
TO postgres_lab_developer;

GRANT CONNECT ON DATABASE postgres_lab
TO postgres_lab_readonly;

-------------------------------------------------------------------------------

-- SECTION: 4 => Connect to postgres_lab

\c postgres_lab

-------------------------------------------------------------------------------

-- SECTION: 5 => Create the application schema

-- Create the app schema and assign ownership to the developer role.
-- This allows the developer role to create and manage objects within it.

CREATE SCHEMA app
AUTHORIZATION postgres_lab_developer;

-------------------------------------------------------------------------------

-- SECTION: 6 => Configure developer permissions

-- Allow the developer role to use the app schema.

GRANT USAGE, CREATE ON SCHEMA app
TO postgres_lab_developer;

-- The developer role owns the schema and will own objects created
-- when members use SET ROLE postgres_lab_developer.
--
-- As the owner, it can perform CRUD operations and manage those objects.

-------------------------------------------------------------------------------

-- SECTION: 7 => Configure readonly permissions

-- Allow the readonly role to access objects within the app schema.

GRANT USAGE ON SCHEMA app
TO postgres_lab_readonly;

-- Allow the readonly role to read existing tables and views.

GRANT SELECT ON ALL TABLES IN SCHEMA app
TO postgres_lab_readonly;

-- Allow the readonly role to inspect existing sequences.

GRANT SELECT ON ALL SEQUENCES IN SCHEMA app
TO postgres_lab_readonly;

-------------------------------------------------------------------------------

-- SECTION: 8 => Configure default privileges

-- Default privileges determine what permissions are automatically
-- granted on objects created in the future.
--
-- These settings apply to objects created by postgres_lab_developer
-- within the app schema.

-- Automatically allow the readonly role to read future tables and views.

ALTER DEFAULT PRIVILEGES FOR ROLE postgres_lab_developer
IN SCHEMA app
GRANT SELECT ON TABLES
TO postgres_lab_readonly;

-- Automatically allow the readonly role to inspect future sequences.

ALTER DEFAULT PRIVILEGES FOR ROLE postgres_lab_developer
IN SCHEMA app
GRANT SELECT ON SEQUENCES
TO postgres_lab_readonly;

-------------------------------------------------------------------------------

-- SECTION: 9 => Inspect the roles

-- List PostgreSQL roles and their attributes.

\du+

-------------------------------------------------------------------------------

-- SECTION: 10 => Inspect database permissions

-- List databases and their access privileges.

\l+

-------------------------------------------------------------------------------

-- SECTION: 11 => Inspect schema permissions

-- List schemas, their owners and privileges.

\dn+

-------------------------------------------------------------------------------

-- SECTION: 12 => Using the developer role

-- Individual login accounts will receive membership in the developer role
-- in the next guide.
--
-- Members should use SET ROLE when creating or managing objects.
-- This ensures that objects are owned by postgres_lab_developer.

SET ROLE postgres_lab_developer;

-- Return to the original login role.

RESET ROLE;

-------------------------------------------------------------------------------

-- SECTION: 13 => Summary
--
-- postgres_lab_developer:
--
-- - Cannot log in directly.
-- - Can connect to postgres_lab.
-- - Can create and manage objects within the app schema.
-- - Can perform CRUD operations on objects it owns.
-- - Cannot create databases or manage PostgreSQL roles.
--
-- postgres_lab_readonly:
--
-- - Cannot log in directly.
-- - Can connect to postgres_lab.
-- - Can read tables and views within the app schema.
-- - Can inspect sequences.
-- - Cannot modify data or manage database objects.
--
-- Individual login accounts will receive permissions through membership
-- in one or both of these roles.
--
-- No individual database or object privileges need to be granted
-- directly to those login accounts.
