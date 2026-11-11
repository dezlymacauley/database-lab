/*
    ABOUT: Confirming the size (in bytes) of a column type
*/
-------------------------------------------------------------------------------

-- SECTION: 1 => Storing a number value that has no decimals

SELECT
    pg_column_size(1::INT2) AS int2_aka_smallint_size,
    pg_column_size(1::INT4) AS int4_aka_int_size,
    pg_column_size(1::INT8) AS int8_aka_bigint_size;

/*

+------------------------+-------------------+----------------------+
| int2_aka_smallint_size | int4_aka_int_size | int8_aka_bigint_size |
|------------------------+-------------------+----------------------|
| 2                      | 4                 | 8                    |
+------------------------+-------------------+----------------------+

*/
-------------------------------------------------------------------------------

-- SECTION: 2 => Storing a number value has decimals

SELECT
    pg_column_size(1.5::FLOAT4) AS float4_aka_real,
    pg_column_size(1.5::FLOAT8) AS float8_aka_double_precision,
    pg_column_size(1.5::DECIMAL) AS decimal_aka_numeric;

/*

+-----------------+-----------------------------+---------------------+
| float4_aka_real | float8_aka_double_precision | decimal_aka_numeric |
|-----------------+-----------------------------+---------------------|
| 4               | 8                           | 10                  |
+-----------------+-----------------------------+---------------------+

*/
-------------------------------------------------------------------------------

-- SECTION: 3 => Storing a `true` or `false` value

SELECT pg_column_size(TRUE::BOOLEAN) AS boolean_size;

/*

+--------------+
| boolean_size |
|--------------|
| 1            |
+--------------+

*/
-------------------------------------------------------------------------------
