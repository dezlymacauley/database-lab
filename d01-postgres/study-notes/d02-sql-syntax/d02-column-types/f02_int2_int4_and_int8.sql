/*
    ABOUT: INT2, INT4, and INT8

    Use these when you want to store numbers that do not have any decimals.

    These are the integer types in Postgres:

    ---------------------------------------------------------------------------

    INT2 or SMALLINT (2 bytes | 16 bits)

    Range:
    -32,768 to 32,767
    ---------------------------------------------------------------------------

    INT4 or INT (4 bytes | 32 bits)

    Range:
    -2,147,483,648 to 2,147,483,647
    ---------------------------------------------------------------------------

    INT8 or BIGINT (8 bytes | 64 bits)

    Range:
    -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807
    ---------------------------------------------------------------------------

*/

-------------------------------------------------------------------------------

-- This will create a table called `example_table` in the database schema
-- called `study_notes`

CREATE TABLE study_notes.example_table (
    age SMALLINT CHECK (age > 0),
    high_score BIGINT
);
-------------------------------------------------------------------------------

-- NOTE: Postgres does not have a column type for unsigned integers

-- If you want an integer column to only have positive values 
-- then you have to specify a check constraint when you create the table.

-- E.g. CHECK (age > 0)
-------------------------------------------------------------------------------

-- Adding a single row to the table 
INSERT INTO study_notes.example_table (
    age, high_score
)
VALUES
(33, 50);
-------------------------------------------------------------------------------

-- Adding multiple rows to the table
INSERT INTO study_notes.example_table (
    age, high_score
)
VALUES
(18, 50),
(20, 90),
(10, 100);
-------------------------------------------------------------------------------

SELECT
    age,
    high_score
FROM study_notes.example_table;

/*

+-----+------------+
| age | high_score |
|-----+------------|
| 33  | 50         |
| 18  | 50         |
| 20  | 90         |
| 10  | 100        |
+-----+------------+

*/
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS study_notes.example_table;
-------------------------------------------------------------------------------
