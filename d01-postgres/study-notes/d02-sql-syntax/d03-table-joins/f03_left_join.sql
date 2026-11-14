/*
    ABOUT: LEFT JOIN

    A `LEFT JOIN` is a type of table JOIN in SQL.

    The way it works is simple:

    1. You select a LEFT table and a RIGHT table.

    2. PostgreSQL matches rows between the two tables using
    a condition specified with the `ON` keyword.

    3. PostgreSQL returns ALL rows from the LEFT table,
    including rows that do not have a match in the RIGHT table.

    4. If there is no matching row in the RIGHT table,
    PostgreSQL returns NULL values for its columns.

    In this example, an online store wants to generate a monthly
    sales report showing every product and its orders.

    Products that haven't been ordered during the month
    must also appear in the report.
*/
-------------------------------------------------------------------------------

-- STEP: 1 => Create the table

-------------------------------------------------------------------------------

-- Each row stores the details of a registered customer.
CREATE TABLE study_notes.customers (
    customer_id INT PRIMARY KEY,
    customer_name TEXT,
    email TEXT
);
-------------------------------------------------------------------------------

-- Each row stores the details of a product that can be 
-- bought from the business.
CREATE TABLE study_notes.products (
    product_id INT PRIMARY KEY,
    product_name TEXT,
    price DECIMAL(10, 2)
);
-------------------------------------------------------------------------------

-- Each row stores an order placed by a customer.
-- Each order can be made up of a single item,
-- or multiple items because it is possible for a customer to make one order
-- that contains multiple product.

-- This table shares a relationship with the `customer_id` column of the
-- customers table because the business needs to be able to track which
-- customer made the order.
CREATE TABLE study_notes.orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT REFERENCES study_notes.customers(customer_id)
);
-------------------------------------------------------------------------------

-- Each row stores the details of each individual product that was ordered.
-- This table shares a relationship with:
-- the `order_id` of the orders tables, so that the business can keep track
-- of which order each item is part of.

-- The table also shares a relationship with:
-- the `product_id` column of te product table because the business needs
-- to be able to track the which products customers are ordering the most,
-- and which products need better marketing.
CREATE TABLE study_notes.order_items (
    order_item_id INT PRIMARY KEY,
    quantity INT,
    order_id INT REFERENCES study_notes.orders(order_id),
    product_id INT REFERENCES study_notes.products(product_id)
);
-------------------------------------------------------------------------------

-- If I run this command: \dt study_notes.*
-- This should be the output

/*

+-------------+-------------+-------+----------------+
| Schema      | Name        | Type  | Owner          |
|-------------+-------------+-------+----------------|
| study_notes | customers   | table | dezly_macauley |
| study_notes | order_items | table | dezly_macauley |
| study_notes | orders      | table | dezly_macauley |
| study_notes | products    | table | dezly_macauley |
+-------------+-------------+-------+----------------+

*/
-------------------------------------------------------------------------------

-- STEP: 2 => Add the data for each table

-------------------------------------------------------------------------------

INSERT INTO study_notes.customers (
    customer_id,
    customer_name,
    email
)
VALUES
(1, 'Oliver', 'oliver@gmail.com'),
(2, 'Charlotte', 'charlotte@gmail.com'),
(3, 'Harry', 'harry@gmail.com');
-------------------------------------------------------------------------------

INSERT INTO study_notes.products (
    product_id,
    product_name,
    price
)
VALUES
(1, 'Wireless Mouse', 25.00),
(2, 'Mechanical Keyboard', 89.99),
(3, 'USB-C Hub', 45.00),
(4, 'Laptop Stand', 35.00),
(5, 'Webcam', 59.99),
(6, 'Monitor', 199.99);
-------------------------------------------------------------------------------

INSERT INTO study_notes.orders (
    order_id,
    order_date,
    customer_id
)
VALUES
(101, '2026-11-02', 1),
(102, '2026-11-08', 2),
(103, '2026-10-28', 3),
(104, '2026-11-15', 1),
(105, '2026-11-21', 2),
(106, '2026-12-02', 3);
-------------------------------------------------------------------------------

INSERT INTO study_notes.order_items (
    order_id,
    quantity,
    order_item_id,
    product_id
)
VALUES
-- Order 101: Oliver
(101, 2, 1, 1),
(101, 1, 2, 2),
(101, 3, 3, 3),

-- Order 102: Charlotte
(102, 1, 4, 1),
(102, 1, 5, 5),

-- Order 103: Harry (October)
(103, 3, 6, 3),

-- Order 104: Oliver
(104, 1, 7, 1),
(104, 1, 8, 4),

-- Order 105: Charlotte
(105, 2, 9, 2),
(105, 1, 10, 4),

-- Order 106: Harry (December)
(106, 2, 11, 5);
-------------------------------------------------------------------------------

-- The four tables look like this:

/*

-- Customers
+-------------+---------------+---------------------+
| customer_id | customer_name | email               |
|-------------+---------------+---------------------|
| 1           | Oliver        | oliver@gmail.com    |
| 2           | Charlotte     | charlotte@gmail.com |
| 3           | Harry         | harry@gmail.com     |
+-------------+---------------+---------------------+

-- Products
+------------+---------------------+--------+
| product_id | product_name        | price  |
|------------+---------------------+--------|
| 1          | Wireless Mouse      |  25.00 |
| 2          | Mechanical Keyboard |  89.99 |
| 3          | USB-C Hub           |  45.00 |
| 4          | Laptop Stand        |  35.00 |
| 5          | Webcam              |  59.99 |
| 6          | Monitor             | 199.99 |
+------------+---------------------+--------+

-- Orders
+----------+------------+-------------+
| order_id | order_date | customer_id |
|----------+------------+-------------|
| 101      | 2026-11-02 | 1           |
| 102      | 2026-11-08 | 2           |
| 103      | 2026-10-28 | 3           |
| 104      | 2026-11-15 | 1           |
| 105      | 2026-11-21 | 2           |
| 106      | 2026-12-02 | 3           |
+----------+------------+-------------+

-- Order Items
+---------------+----------+----------+------------+
| order_item_id | quantity | order_id | product_id |
|---------------+----------+----------+------------|
| 1             | 2        | 101      | 1          |
| 2             | 1        | 101      | 2          |
| 3             | 3        | 101      | 3          |
| 4             | 1        | 102      | 1          |
| 5             | 1        | 102      | 5          |
| 6             | 3        | 103      | 3          |
| 7             | 1        | 104      | 1          |
| 8             | 1        | 104      | 4          |
| 9             | 2        | 105      | 2          |
| 10            | 1        | 105      | 4          |
| 11            | 2        | 106      | 5          |
+---------------+----------+----------+------------+

*/

-------------------------------------------------------------------------------

-- EXAMPLE: 1 =>

SELECT
    products.product_id,
    products.product_name
FROM study_notes.products
    LEFT JOIN study_notes.order_items
        ON products.product_id = order_items.product_id
WHERE order_items.product_id IS NULL;
-------------------------------------------------------------------------------

/*
    EXAMPLE: FINDING ALL PRODUCTS AND THEIR NOVEMBER ORDERS

    The online store wants a monthly sales report showing
    every product alongside its orders placed during November 2026.

    Products that haven't been ordered during November
    must also appear.

    First, we retrieve the order items belonging to orders
    placed during November.

    Then, we use a LEFT JOIN to match those order items
    against ALL the products in the store.
*/

-- STEP 1: Retrieve order items belonging to November orders.
WITH november_order_items AS (
    SELECT
        order_items.product_id,
        orders.order_id,
        orders.order_date,
        order_items.quantity
    FROM study_notes.order_items
        INNER JOIN study_notes.orders
            ON order_items.order_id = orders.order_id
    WHERE
        orders.order_date >= '2026-11-01'
        AND orders.order_date < '2026-12-01'
)

-- STEP 2: Match the November order items against ALL products.
SELECT
    products.product_id,
    products.product_name,
    products.price,
    november_order_items.order_id,
    november_order_items.order_date,
    november_order_items.quantity
FROM study_notes.products
    LEFT JOIN november_order_items
        ON products.product_id = november_order_items.product_id
ORDER BY
    products.product_id,
    november_order_items.order_id;
-------------------------------------------------------------------------------

/*
    EXPECTED OUTPUT:

    +------------+---------------------+--------+----------+------------+----------+
    | product_id | product_name        | price  | order_id | order_date | quantity |
    |------------+---------------------+--------+----------+------------+----------|
    | 1          | Wireless Mouse      | 25.00  | 101      | 2026-11-02 | 2        |
    | 1          | Wireless Mouse      | 25.00  | 102      | 2026-11-08 | 1        |
    | 1          | Wireless Mouse      | 25.00  | 104      | 2026-11-15 | 1        |
    | 2          | Mechanical Keyboard | 89.99  | 101      | 2026-11-02 | 1        |
    | 2          | Mechanical Keyboard | 89.99  | 105      | 2026-11-21 | 2        |
    | 3          | USB-C Hub           | 45.00  | NULL     | NULL       | NULL     |
    | 4          | Laptop Stand        | 35.00  | 104      | 2026-11-15 | 1        |
    | 4          | Laptop Stand        | 35.00  | 105      | 2026-11-21 | 1        |
    | 5          | Webcam              | 59.99  | 102      | 2026-11-08 | 1        |
    | 6          | Monitor             | 199.99 | NULL     | NULL       | NULL     |
    +------------+---------------------+--------+----------+------------+----------+

    ---------------------------------------------------------------------------

    IMPORTANT:

    1. Every product appears in the results.

    This includes the USB-C Hub and Monitor.

    The USB-C Hub has an order from October, but no orders
    during November.

    The Monitor has never been ordered.

    2. Products can appear more than once.

    The Wireless Mouse appears three times because it was
    included in three different November orders.

    The Mechanical Keyboard appears twice because it was
    included in two different November orders.

    3. Orders from outside November are excluded.

    Harry's October order and December order do not appear
    in the November report.

    4. Missing order information is represented by NULL.

    The USB-C Hub and Monitor have no matching November
    order items, so PostgreSQL returns NULL for those columns.

    5. The LEFT JOIN is responsible for preserving every product.

    Even when a product has no matching November order items,
    it remains in the results.

    ---------------------------------------------------------------------------

    IMPORTANT: UNDERSTANDING THE QUERY

    The `november_order_items` CTE retrieves order items
    belonging to orders placed during November.

    The INNER JOIN inside the CTE connects each order item
    to its corresponding order so that we can check the order date.

    The LEFT JOIN then matches those November order items
    against the products table.

    Notice that `products` is the LEFT table.

    This means PostgreSQL preserves every product, even when
    the CTE contains no matching November order items.

    This is the main purpose of the LEFT JOIN in this example.
*/
-------------------------------------------------------------------------------

-- SECTION: 4 => Cleanup

DROP TABLE IF EXISTS study_notes.order_items;
DROP TABLE IF EXISTS study_notes.orders;
DROP TABLE IF EXISTS study_notes.products;
DROP TABLE IF EXISTS study_notes.customers;
-------------------------------------------------------------------------------
