/*

    ABOUT: Float4 (aka real)

    `float4` uses 4 bytes of storage and provides approximately
    6 decimal digits of precision.

    Use case:
    1. You want to store a numerical value that has decimals.

    2. You want floating-point arithmetic, which is generally faster than
       working with `numeric` values.

    3. You are willing to accept the trade-off of approximate precision.
       In simple terms, the stored value might not exactly match the
       decimal value you originally provided.

    4. Do not use this column type to store financial data when exact
       decimal representation is required. Use `numeric` (aka `decimal`)
       instead.
*/
-------------------------------------------------------------------------------

CREATE TABLE study_notes.example_table (
    interest_rate FLOAT4
);
-------------------------------------------------------------------------------

-- NOTE: Unlike NUMERIC, FLOAT4 does not allow you to specify precision
-- and scale.

-- PostgreSQL uses binary floating-point representation.
-- This means some decimal values cannot be represented exactly.

INSERT INTO study_notes.example_table (interest_rate)
VALUES
(18.621),
(718.621),
(5.6472),
(5.6475),
(6.1),
(12);
-------------------------------------------------------------------------------

SELECT interest_rate
FROM study_notes.example_table;

/*

+---------------+
| interest_rate |
|---------------|
|  18.621       |
| 718.621       |
|   5.6472      |
|   5.6475      |
|   6.1         |
|  12.0         |
+---------------+

*/
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS study_notes.example_table;
-------------------------------------------------------------------------------
