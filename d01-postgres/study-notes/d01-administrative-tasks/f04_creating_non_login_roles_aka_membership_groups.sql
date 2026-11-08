/*
    ABOUT: Creating non-login roles (aka membership groups)

    ___________________________________________________________________________

    In Postgres a non-login role a named collection of rules,
    that can be used as a membership group that assigns permissions to
    login-roles.

    The login-role `postgres` is meant for administrative tasks.
    It should not be used for interacting with databases,
    even though it has the ability to do so.

    It's better to create additional login-roles with restricted permissions
    that will be used for interacting with the databases.

    However, before creating additional roles,
    it's best practice to do the following:

    1. Create `non-login role` that define access rules.
    2. Then create a `login-role`.
    3. Make the `login-role` a member of 
    the `non-login` role (aka membership group)
    ___________________________________________________________________________

    The whole point of a `non-login` is that it allows you to manage 
    the permissions of multiple `login-roles`.

    E.g. If you had 10 login-roles, and you assigned permissions directly
    without using a `non-login` role (membership group),
    then you'd have to keep track of 10 different access rules.

    However if you created 2 `non-login` roles, 
    e.g. `postgres_lab_developer_group`, `postgres_lab_readonly_group`

    Then placed each of the 10 login-roles into the relevant group,
    then you only have to manage 2 sets of access rules.
    ___________________________________________________________________________

    In this guide I will create two `roles` (aka membership groups) 
    for interacting with the `postgres_lab` database:

    1. `postgres_lab_developer_group`
    2. `postgres_lab_readonly_group`
    ___________________________________________________________________________

    1. `postgres_lab_developer_group`

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
-- This is what indicates that I am creating a non-login role.

-- NOSUPERUSER
-- A member of the `postgres_lab_developer_group` role cannot have 
-- unrestricted administrator privileges.

-- NOCREATEDB
-- A member of this role can't create new databases.

-- NOCREATEROLE
-- A member of this role can't create or manage other PostgreSQL roles.
-- Remember: PostgreSQL users are also roles.

-- NOREPLICATION
-- A member of this role can't perform special PostgreSQL 
-- replication operations.
-- Replication is used to copy and synchronise data between servers.

-- NOBYPASSRLS
-- A member of this role cannot bypass Row-Level Security (RLS).
-- RLS allows PostgreSQL to restrict which rows a user can access.
-- E.g. A company could use RLS to ensure that employees only see records 
-- that belong to their department.
-------------------------------------------------------------------------------

-- SECTION: 3 => Creating the roles

-- The naming convention I follow when creating a role is:
-- database_name_group_name

CREATE ROLE postgres_lab_developer_group
NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS;

CREATE ROLE postgres_lab_readonly_group
NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS;
-------------------------------------------------------------------------------

-- SECTION: 4 => Viewing the `roles` of a Postgres Cluster

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
Role name  | postgres_lab_developer_group
Attributes | Cannot login

-[ RECORD 3 ]----------------------------------------------------------
Role name  | postgres_lab_readonly_group
Attributes | Cannot login

*/
-------------------------------------------------------------------------------

-- SECTION: 5 => Specify what databases each member of the role should 
-- be allowed to connect to

-- Allow the developer role to connect to postgres_lab.
GRANT CONNECT ON DATABASE postgres_lab
TO postgres_lab_developer_group;

-- Allow the readonly role to connect to postgres_lab.
GRANT CONNECT ON DATABASE postgres_lab
TO postgres_lab_readonly_group;
-------------------------------------------------------------------------------

-- SECTION: 6 => Specify what schemas a member of the role should
-- be allowed to access

-- Allow the developer role to access and create objects inside `study_notes`.
GRANT USAGE, CREATE ON SCHEMA study_notes
TO postgres_lab_developer_group;

-- Allow the readonly role to access objects inside `study_notes`.
GRANT USAGE ON SCHEMA study_notes
TO postgres_lab_readonly_group;
-------------------------------------------------------------------------------

-- SECTION: 7 => Specify what table operations a member of the role should
-- be allowed to perform on existing tables

-- Allow the developer role to perform CRUD operations on all existing tables
-- inside the `study_notes` schema.
GRANT INSERT, SELECT, UPDATE, DELETE ON ALL TABLES IN SCHEMA study_notes
TO postgres_lab_developer_group;

-- Allow the readonly role to read all existing tables
-- inside the `study_notes` schema.
GRANT SELECT ON ALL TABLES IN SCHEMA study_notes
TO postgres_lab_readonly;
-------------------------------------------------------------------------------
