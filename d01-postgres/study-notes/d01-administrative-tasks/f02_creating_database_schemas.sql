/*
    ABOUT: Creating Database Schemas

    In the previous guide, I created a database called `postgres_lab`.

    A database is where PostgreSQL stores and manages data.

    However, a database can contain many different database objects,
    such as tables, views, functions and sequences.

    A `schema` is a way of organising these objects inside a database.

    You can think of a schema as a folder inside a database.
    ---------------------------------------------------------------------------
    /*

        PostgreSQL Cluster
        |
        +-- Database 1: postgres (built-in)
        |   |
        |   +-- Schema 1: public
        |       |
        |       +-- Table 1
        |       +-- Table 2
        |       +-- Table 3
        |
        +-- Database 2: template0 (built-in)
        |   |
        |   +-- Schema 1: public
        |       |
        |       +-- Table 1
        |       +-- Table 2
        |       +-- Table 3
        |
        +-- Database 3: template1 (built-in)
        |   |
        |   +-- Schema 1: public
        |       |
        |       +-- Table 1
        |       +-- Table 2
        |       +-- Table 3
        |
        +-- Database 4: postgres_lab (custom created)
            |
            +-- Schema 1: public
            |   |
            |   +-- Table 1
            |   +-- Table 2
            |   +-- Table 3
            |
            +-- Schema 2: study_notes
                |
                +-- Table 1
                +-- Table 2
                +-- Table 3

    */

    ---------------------------------------------------------------------------

    For example, imagine an application that manages customers and orders.

    Instead of placing every database object in one schema,
    you could organise them into separate schemas:

    1. `customers` - Contains objects related to customers.
    2. `orders`    - Contains objects related to orders.

    This makes it easier to organise database objects like tables
    as an application grows.

    Database: ecommerce
    |
    +-- Schema: customers
    |   |
    |   +-- Table: customer_profiles
    |   +-- Table: customer_addresses
    |   +-- Table: customer_preferences
    |
    +-- Schema: orders
        |
        +-- Table: customer_orders
        +-- Table: order_items
        +-- Table: order_payments

*/
-------------------------------------------------------------------------------

-- SECTION: 1 => Connecting to the `postgres_lab` database

-- First, connect to the `postgres` database using the `postgres` user.

-- For my workflow I can do this by running this command:

/*

    connect-admin

*/
-------------------------------------------------------------------------------

-- SECTION: 2 => Log into the `postgres_lab` database

/*

    \c postgres_lab

*/
-------------------------------------------------------------------------------

-- SECTION: 3 => Viewing the schemas in the database

-- To list the schemas in the current database,
-- run this command:

/*

\dn

*/
-------------------------------------------------------------------------------

-- This is the output

/*

List of schemas
-[ RECORD 1 ]------------
Name  | public
Owner | pg_database_owner

*/
-------------------------------------------------------------------------------

-- Every newly created PostgreSQL database has a default schema 
-- called `public`.
-- The `Owner` value of this schema is also set to `pg_database_owner`.

-- Any new database you create will have these exact settings.
-------------------------------------------------------------------------------

-- NOTE: Postgres does not force you to create additional database schemas

-- If a database has only a small number of tables, you could just put all
-- of those tables inside the default schema.
-------------------------------------------------------------------------------

-- SECTION: 4 => Creating a database schema

-- To create a new schema in the `postgres_lab` database called `study_notes`,
-- run this SQL command:

CREATE SCHEMA study_notes;
-------------------------------------------------------------------------------

-- To view the schemas in the current database, run:

/*

\dn

*/
-------------------------------------------------------------------------------

-- Your output should now look something like this:

/*

List of schemas

-[ RECORD 1 ]------------
Name  | public
Owner | pg_database_owner

-[ RECORD 2 ]------------
Name  | study_notes
Owner | postgres

*/
-------------------------------------------------------------------------------

-- SECTION: 5 => Deleting a schema

-- DROP SCHEMA study_notes;

-- I'll keep this schema because I plan to use it in future guides.
-------------------------------------------------------------------------------
