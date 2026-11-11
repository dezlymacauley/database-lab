/*
    ABOUT: Confirming the size (in bytes) of a column type
*/
-------------------------------------------------------------------------------

-- SECTION: 1 => Storing a number value that has no decimals

SELECT
    pg_column_size(1::INT8) AS int8_aka_bigint_size,
    pg_column_size(1::INT4) AS int4_aka_int_size,
    pg_column_size(1::INT2) AS int2_aka_smallint_size;

/*

+----------------------+-------------------+------------------------+
| int8_aka_bigint_size | int4_aka_int_size | int2_aka_smallint_size |
|----------------------+-------------------+------------------------|
| 8                    | 4                 | 2                      |
+----------------------+-------------------+------------------------+

*/
-------------------------------------------------------------------------------

-- SECTION: 2 => Storing a number value has decimals

SELECT
    pg_column_size(1.5::DECIMAL) AS decimal_aka_numeric,
    pg_column_size(1.5::FLOAT8) AS float8_aka_double_precision,
    pg_column_size(1.5::FLOAT4) AS float4_aka_real;

/*

+---------------------+-----------------------------+-----------------+
| decimal_aka_numeric | float8_aka_double_precision | float4_aka_real |
|---------------------+-----------------------------+-----------------|
| 10                  | 8                           | 4               |
+---------------------+-----------------------------+-----------------+

*/
-------------------------------------------------------------------------------

-- SECTION: 3 => Storing a `true` or `false` value

SELECT pg_column_size(TRUE::BOOLEAN) AS boolean_column_type;

/*

+---------------------+
| boolean_column_type |
|---------------------|
| 1                   |
+---------------------+

*/
-------------------------------------------------------------------------------
