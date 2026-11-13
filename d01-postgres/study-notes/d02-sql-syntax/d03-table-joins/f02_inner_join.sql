/*
    ABOUT: INNER JOIN

    An INNER JOIN is used to combine rows from two or more tables
    when there is a matching value between the specified columns.

    Only rows that have a match in both tables will be returned.

    The columns being compared do not necessarily need to have
    the same name, but their values must be compatible.
*/

-------------------------------------------------------------------------------

-- STEP: 1 => Creating both tables

-- This table stores the information of each customer
CREATE TABLE study_notes.customers (
    customer_id INT PRIMARY KEY,
    customer_name TEXT,
    email TEXT,
    address TEXT
);

-- This table stores the information of each customer
CREATE TABLE study_notes.orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES study_notes.customers(customer_id),
    total_amount DECIMAL(10, 2),
    order_date DATE
);
-------------------------------------------------------------------------------

-- NOTE: Both of these tables share the column `customer_id`

-- The declaration below, establishes the relationship
-- customer_id INT REFERENCES study_notes.customers(customer_id),

-- An `INNER JOIN` will only return rows where there is a matching
-- `customer_id` value in both tables.

-------------------------------------------------------------------------------

-- STEP: 2 => Inserting data into both tables 

-- Adding some example data to the `orders` table
INSERT INTO study_notes.customers (
    customer_id,
    name,
    email,
    address
)
VALUES
(1, 'Alice Johnson', 'alice@email.com', '123 Maple St'),
(2, 'Bob Smith', 'bob@email.com', '456 Oak Ave'),
(3, 'Carol White', 'carol@email.com', '789 Pine Rd'),
(4, 'David Brown', 'david@email.com', '321 Elm St'),
(5, 'Eve Davis', 'eve@email.com', '654 Birch Ln');

-------------------------------------------------------------------------------

-- Adding some example data to the `orders` table
INSERT INTO study_notes.orders (
    order_id,
    customer_id,
    total_amount,
    order_date
)
VALUES
(101, 1, 150.50, '2024-11-01'),
(102, 2, 89.99, '2024-11-02'),
(103, 1, 200.00, '2024-11-03'),
(104, 3, 45.75, '2024-11-04'),
(105, 2, 120.25, '2024-11-05'),
(106, 4, 300.00, '2024-11-06'),
(107, 1, 75.50, '2024-11-07');

-------------------------------------------------------------------------------

/*
    EXAMPLE: 1 => I want to see the top 4 most expensive orders,
    and I want to know which customers made each of those orders.

*/

SELECT
    customers.customer_id,
    customers.name,
    orders.order_id,
    orders.order_date,
    orders.total_amount
FROM study_notes.customers AS customers
    INNER JOIN study_notes.orders AS orders
        ON customers.customer_id = orders.customer_id
ORDER BY orders.total_amount DESC
LIMIT 4;

-------------------------------------------------------------------------------

/*
    EXPECTED OUTPUT:

    +-------------+---------------+----------+------------+--------------+
    | customer_id | name          | order_id | order_date | total_amount |
    |-------------+---------------+----------+------------+--------------|
    | 4           | David Brown   | 106      | 2024-11-06 | 300.00       |
    | 1           | Alice Johnson | 103      | 2024-11-03 | 200.00       |
    | 1           | Alice Johnson | 101      | 2024-11-01 | 150.50       |
    | 2           | Bob Smith     | 105      | 2024-11-05 | 120.25       |
    +-------------+---------------+----------+------------+--------------+

    ---------------------------------------------------------------------------

    IMPORTANT:

    The customer with a `customer_id` of 5 does not appear in the results.

    This is because the value 5 only exists in the `customers` table.

    Eve Davis has not made any orders, so there is no matching
    `customer_id` in the `orders` table.

    An INNER JOIN excludes rows that do not have a match in both tables.
*/

-------------------------------------------------------------------------------

/*
    EXAMPLE 2: FINDING ALL ORDERS MADE BY A SPECIFIC CUSTOMER

    I want to see all of the orders made by the customer
    with a `customer_id` of 1.

    The WHERE clause filters the results to only include
    orders belonging to that customer.

    The ORDER BY clause sorts the orders by their total amount
    in descending order.
*/

SELECT
    customers.customer_id,
    customers.name,
    orders.order_id,
    orders.order_date,
    orders.total_amount
FROM study_notes.customers AS customers
    INNER JOIN study_notes.orders AS orders
        ON customers.customer_id = orders.customer_id
WHERE customers.customer_id = 1
ORDER BY orders.total_amount DESC;

-------------------------------------------------------------------------------

/*
    EXPECTED OUTPUT:

    +-------------+---------------+----------+------------+--------------+
    | customer_id | name          | order_id | order_date | total_amount |
    |-------------+---------------+----------+------------+--------------|
    | 1           | Alice Johnson | 103      | 2024-11-03 | 200.00       |
    | 1           | Alice Johnson | 101      | 2024-11-01 | 150.50       |
    | 1           | Alice Johnson | 107      | 2024-11-07 | 75.50        |
    +-------------+---------------+----------+------------+--------------+
*/

-------------------------------------------------------------------------------

-- Removing the example tables

DROP TABLE IF EXISTS study_notes.orders;
DROP TABLE IF EXISTS study_notes.customers;

-------------------------------------------------------------------------------
