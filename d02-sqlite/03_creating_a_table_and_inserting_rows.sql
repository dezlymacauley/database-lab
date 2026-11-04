/*
    ABOUT: Creating a table and inserting rows

    How to load this file into your SQLite database?

    Login into litecli then run this command:
    .read 02-study-notes/03_creating_a_table_and_inserting_rows.sql

    To confirm that the table was created, run this command:
    .tables;

    You should get this output:

    +--------+
    | name   |
    +--------+
    | people |
    +--------+

*/

CREATE TABLE people (
-- Define the columns of the database
    first TEXT,
    last TEXT,
    age INTEGER
);

INSERT INTO people (
-- List the columns in a database that will receive data
-- from this insert statement
    first, last, age
) VALUES
-- Each pair of round brackets represents a new row
-- Always use single quotes when inserting text values and ensure that
-- the order of the values matches the order that you declared above:
-- first, last, age
('John', 'Doe', 30),
('Jane', 'Smith', 25);
