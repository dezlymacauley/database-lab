/*
    ABOUT: Managing Roles

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

-------------------------------------------------------------------------------

-- SECTION: 2 => Create the developer role

CREATE ROLE postgres_lab_developer
NOLOGIN
NOSUPERUSER
NOCREATEDB
NOCREATEROLE
NOREPLICATION
NOBYPASSRLS;
-------------------------------------------------------------------------------

-- `NOLOGIN` means that the `postgres_lab_developer` user

-------------------------------------------------------------------------------

-- SECTION: 3 => Create the readonly role

CREATE ROLE postgres_lab_readonly
NOLOGIN
NOSUPERUSER
NOCREATEDB
NOCREATEROLE
NOREPLICATION
NOBYPASSRLS;

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
