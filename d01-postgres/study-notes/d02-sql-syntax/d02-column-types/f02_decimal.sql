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

-- Precision means the total number of digits the number has:
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
-------------------------------------------------------------------------------

-- This insert will succeed
INSERT INTO example_table (interest_rate)
VALUES
-- The precision was set to 5

-- This value will be stored because it is 5 digits 
-- However this number 4 digits
-- However the decimals will be rounded to 3 decimals
(5.6472);

-- This number will be stored as 5.647
-------------------------------------------------------------------------------


-- This will work because it is a total of 5 digits but the decimals 
-- will be rounded up.
--
INSERT INTO financial_info (description, interest_rate)
VALUES
-- The precision was set to 5, and the scale was set to 3 
-- This value will be stored because it is 5 digits 
-- However the decimals will be rounded to 3 decimals
('This will be rounded up', 5.6475);
--
-- This number will be stored as 5.648
--
-- _______________________________________________________________________________
--
-- This will work.
-- Postgres will add some extra zeros add that end to keep the scale consistent.
INSERT INTO financial_info (description, interest_rate)
VALUES
('Less than five digits', 3.1);
--
-- The number will be stored as 3.100 

-- _______________________________________________________________________________

-- This will work. Postgres will add the decimal and the extra zeros.
INSERT INTO financial_info (description, interest_rate)
VALUES
('Whole number', 12);
--
-- 12.000.

-- _______________________________________________________________________________

-- select * from financial_info;
-- +---------------------------+---------------+
-- | description               | interest_rate |
-- |---------------------------+---------------|
-- | normal example            | 18.621        |
-- | This will be rounded down | 5.647         |
-- | This will be rounded up   | 5.648         |
-- | Less than five digits     | 3.100         |
-- | Whole number              | 12.000        |
-- +---------------------------+---------------+

-- _______________________________________________________________________________
