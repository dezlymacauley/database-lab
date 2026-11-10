/*
    ABOUT: Checking the number of rows in a table
*/
-------------------------------------------------------------------------------

-- I'm going to create a table called `example_table`
-- that only has one column called `interest_rate`
CREATE TABLE study_notes.example_table (
    interest_rate NUMERIC(5, 3)
);

-- I'm going to insert multiple rows of data into the `interest_rate` column,
-- of the `example_table`
INSERT INTO study_notes.example_table (interest_rate)
VALUES
(18.621),
(50.218),
(5.6472),
(5.6475),
(3.723),
(4.21),
(6.1),
(12);
-------------------------------------------------------------------------------

-- Use this command to count the number of rows in a table
SELECT COUNT(*) AS number_of_rows
FROM study_notes.example_table;

/*

+----------------+
| number_of_rows |
|----------------|
| 8              |
+----------------+

*/
-------------------------------------------------------------------------------

-- If I only wanted the see the first 4 results,
-- I can run this query

SELECT interest_rate
FROM study_notes.example_table
ORDER BY interest_rate
LIMIT 4;

/*

+---------------+
| interest_rate |
|---------------|
| 3.723         |
| 4.210         |
| 5.647         |
| 5.648         |
+---------------+

*/
-------------------------------------------------------------------------------
