/*
    ABOUT: Confirming the size (in bytes) of a column type
*/
-------------------------------------------------------------------------------
SELECT
    pg_column_size(1::INT2) AS int2_size,
    pg_column_size(1::INT4) AS int4_size,
    pg_column_size(1::INT8) AS int8_size,
    pg_column_size(TRUE::BOOLEAN) AS boolean_size;

/*

+--------------+-----------+-----------+-----------+
| boolean_size | int2_size | int4_size | int8_size |
|--------------+-----------+-----------+-----------|
| 1            | 2         | 4         | 8         |
+--------------+-----------+-----------+-----------+

*/
-------------------------------------------------------------------------------
