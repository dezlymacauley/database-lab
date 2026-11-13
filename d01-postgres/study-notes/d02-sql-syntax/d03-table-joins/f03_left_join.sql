/*
    ABOUT: LEFT JOIN

    A `LEFT JOIN` is a type of table JOIN in SQL.

    The way it works is simple:
    1. You make a query with a condition that targets a column that is shared
    by multiple tables.

    2. Postgres will show ALL rows from the LEFT table, including rows
    that do not have a match in the RIGHT table.

    3. If there is no matching row in the RIGHT table, Postgres
    will return NULL values for the columns belonging to that table.
*/
-------------------------------------------------------------------------------

-- STEP: 1 => Create tables that have a shared column

-- This table stores the all of products available for sale
CREATE TABLE study_notes.products (
    product_id INT PRIMARY KEY,
    product_name TEXT,
    price DECIMAL(10, 2)
);

-- This table stores details of a custom order for a specific product
CREATE TABLE study_notes.items_in_order (
    order_item_id INT PRIMARY KEY,
    product_id INT REFERENCES study_notes.products(product_id),
    quantity INT
);
-------------------------------------------------------------------------------

-- NOTE: Both of these tables share the column `product_id`

-- The declaration below establishes the relationship
-- product_id INT REFERENCES study_notes.products(product_id),

-- A `LEFT JOIN` will return all rows from the LEFT table,
-- even when there is no matching `product_id` value in the RIGHT table.
-------------------------------------------------------------------------------

-- STEP: 2 => Insert data into both tables

-- Adding some example data to the `products` table
INSERT INTO study_notes.products (
    product_id,
    product_name,
    price
)
VALUES
(1, 'Laptop', 1200.00),
(2, 'Keyboard', 80.00),
(3, 'Mouse', 35.00),
(4, 'Monitor', 350.00),
(5, 'Webcam', 65.00);
-------------------------------------------------------------------------------

-- Adding some example data to the `order_items` table
INSERT INTO study_notes.items_in_order (
    order_item_id,
    product_id,
    quantity
)
VALUES
(101, 1, 2),
(102, 2, 3),
(103, 1, 1),
(104, 4, 2),
(105, 2, 1);
-------------------------------------------------------------------------------

-- Inspect the tables

SELECT
    product_id,
    product_name,
    price
FROM study_notes.products;

SELECT
    order_item_id,
    product_id,
    quantity
FROM study_notes.order_items;

-- For the sake of this example, let's say that these are monthly results.

/*

+------------+--------------+---------+
| product_id | product_name | price   |
|------------+--------------+---------|
| 1          | Laptop       | 1200.00 |
| 2          | Keyboard     |   80.00 |
| 3          | Mouse        |   35.00 |
| 4          | Monitor      |  350.00 |
| 5          | Webcam       |   65.00 |
+------------+--------------+---------+

+---------------+------------+----------+
| order_item_id | product_id | quantity |
|---------------+------------+----------|
| 101           | 1          | 2        |
| 102           | 2          | 3        |
| 103           | 1          | 1        |
| 104           | 4          | 2        |
| 105           | 2          | 1        |
+---------------+------------+----------+

*/
-------------------------------------------------------------------------------

-- EXAMPLE: => 

-- I want to find all products that do not appear in the `order_items` table
-- In simple terms, products that have never been sold this month.

-- Both the `products` table and the `order_items` table have less than
-- 10 rows of data, so it's easy to see that the product id 3 (mouse),
-- and product id 3

-------------------------------------------------------------------------------

/*
    EXAMPLE: 1


    The online store wants to identify products that have not
    appeared in any customer orders.

    This information can help the store identify products
    that may need better marketing or promotion.
*/

-- First select the columns that you want to show from both tables
SELECT
    -- Columns from the `products` table
    products.product_id,
    products.product_name,
    products.price,

    -- Columns from the `order_items` table
    order_items.order_item_id,
    order_items.quantity

-- The keyword `FROM` is followed by the name of the table
-- that contains ALL the records we want to check.
FROM study_notes.products

-- The `LEFT JOIN` keyword is followed by the name of the table
-- that contains the additional information we want to retrieve.
    LEFT JOIN study_notes.order_items

    -- The `ON` keyword is followed by specifying the column
    -- that both tables share.
        ON products.product_id = order_items.product_id

-- The WHERE clause filters the results to only include products
-- that do not have a matching order_item_id.
WHERE order_items.order_item_id IS NULL;
-------------------------------------------------------------------------------

/*

+------------+--------------+-------+---------------+----------+
| product_id | product_name | price | order_item_id | quantity |
|------------+--------------+-------+---------------+----------|
| 5          | Webcam       | 65.00 | <null>        | <null>   |
| 3          | Mouse        | 35.00 | <null>        | <null>   |
+------------+--------------+-------+---------------+----------+

*/
-------------------------------------------------------------------------------




-------------------------------------------------------------------------------

    IMPORTANT:

    The products with a `product_id` of 3 and 5 appear in the results.

    This is because these products exist in the `products` table,
    but do not have a matching `product_id` in the `order_items` table.

    The `LEFT JOIN` includes all products, even when they have
    no matching order items.

    Since the Mouse and Webcam have never appeared in an order,
    the columns belonging to the `order_items` table contain NULL values.

    The WHERE clause filters the results to only include
    products whose `order_item_id` contains a NULL value.


-------------------------------------------------------------------------------

/*
    EXAMPLE 2: FINDING ALL PRODUCTS AND THEIR SALES INFORMATION

    I want to see ALL products available in the online store,
    including products that have never been sold.

    I also want to see how many units of each product were included
    in customer orders whenever that information is available.

    The ORDER BY clause sorts the results by product_id.
*/

SELECT
    products.product_id,
    products.product_name,
    products.price,
    order_items.order_item_id,
    order_items.quantity
FROM study_notes.products
    LEFT JOIN study_notes.order_items
        ON products.product_id = order_items.product_id
ORDER BY products.product_id;
-------------------------------------------------------------------------------

/*
    EXPECTED OUTPUT:

    +------------+--------------+---------+---------------+----------+
    | product_id | product_name | price   | order_item_id | quantity |
    |------------+--------------+---------+---------------+----------|
    | 1          | Laptop       | 1200.00 | 101           | 2        |
    | 1          | Laptop       | 1200.00 | 103           | 1        |
    | 2          | Keyboard     | 80.00   | 102           | 3        |
    | 2          | Keyboard     | 80.00   | 105           | 1        |
    | 3          | Mouse        | 35.00   | NULL          | NULL     |
    | 4          | Monitor      | 350.00  | 104           | 2        |
    | 5          | Webcam       | 65.00   | NULL          | NULL     |
    +------------+--------------+---------+---------------+----------+

    ---------------------------------------------------------------------------

    IMPORTANT:

    Every product appears in the results, including the Mouse
    and Webcam, which have never been sold.

    Products can appear more than once if they have multiple
    matching records in the `order_items` table.

    For example, the Laptop appears twice because it has two
    matching order items.

    A LEFT JOIN does not automatically combine or aggregate
    matching rows into a single row.

    It returns a row for each matching combination.
*/
-------------------------------------------------------------------------------

-- Removing the example tables
DROP TABLE IF EXISTS study_notes.order_items;
DROP TABLE IF EXISTS study_notes.products;
-------------------------------------------------------------------------------
