/*

    ABOUT: Decimal

    This is for numbers that have decimals, 
    and you want a high level of precision for the decimals stored. 
    The trade off is that this column type is much slower to work with than
    the INT column types.

    Also note that if you ever see a SQL query in Postgres with a column type
    set to `numeric`, just know that it is the same as `decimal` 
*/

-------------------------------------------------------------------------------

CREATE TABLE study_notes.example_table (

    -- NOTE: precision and scale

    -- The first number in the brackets is the precision
    -- The second number is the scale
    interest_rate NUMERIC(5, 3)
);
-------------------------------------------------------------------------------

-- NOTE: What are `precision` and `scale`?

-- E.g. 
-- Take this number: `18.621` 

-- Precision means the total number of digits the number is allowed to
-- have is 5. The number can have less than 5 total digits.
-- So this number has 5 digits.

-- Scale means the number of digits after the decimal point:
-- So this number has 3 digits.
-------------------------------------------------------------------------------

-- This insert will succeed
INSERT INTO study_notes.example_table (interest_rate)
VALUES
(18.621);
-------------------------------------------------------------------------------

-- This insert will fail
INSERT INTO study_notes.example_table (interest_rate)
VALUES
-- This will fail because the precision of the interest_rate column was set
-- to 5 digits, and this value has a total of 6 digits
(718.621);

-- It will be stored as:
-- 718.621
-------------------------------------------------------------------------------

-- This insert will succeed
INSERT INTO study_notes.example_table (interest_rate)
VALUES
-- The precision was set to 5
-- This value has a total of 5 digits 

-- The scale was set to 3
-- This number has a total of 4 digits after the decimal point
-- So it will be rounded down to 3 decimal places before being stored.
(5.6472);

-- It will be stored as:
-- 5.647
-------------------------------------------------------------------------------

-- This insert will succeed
INSERT INTO study_notes.example_table (interest_rate)
VALUES

-- The precision was set to 5
-- This value has a total of 5 digits 

-- The scale was set to 3
-- This number has a total of 4 digits after the decimal point
-- So it will be rounded up to 3 decimal places before being stored.
(5.6475);

-- It will be stored as:
-- 5.648
-------------------------------------------------------------------------------

-- This insert wil succeed.
INSERT INTO study_notes.example_table (interest_rate)
VALUES
-- Postgres will add some extra zeros add the end to ensure that the total
-- number of digits after the decimal matches the `scale` (which was set
-- to 3)
(6.1);

-- It will be stored as:
-- 6.100 
-------------------------------------------------------------------------------

-- This will work. 
INSERT INTO study_notes.example_table (interest_rate)
VALUES
(12);

-- It will be stored as:
-- 12.000
-------------------------------------------------------------------------------

SELECT interest_rate FROM study_notes.example_table;

/*

+---------------+
| interest_rate |
|---------------|
| 18.621        |
|  5.647        |
|  5.648        |
|  6.100        |
+---------------+

*/
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS study_notes.example_table;
-------------------------------------------------------------------------------
