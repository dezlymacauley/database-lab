/*
    ABOUT: GROUP BY

    The GROUP BY clause is used to group rows that share the same values
    in one or more columns.

    It is commonly used with aggregate functions to perform calculations
    on each group.

    For example:
        - Count the number of customers in each country.
        - Calculate the average order amount for each customer.
        - Calculate the total sales for each product.

    GROUP BY produces one result row for each group.
*/

-------------------------------------------------------------------------------

-- Example 1: GROUP BY

/*
    Group customers by country.

    Each country appears only once in the result because customers sharing
    the same country are placed into the same group.
*/

SELECT
    customers.country
FROM study_notes.customers AS customers
GROUP BY
    customers.country;

-------------------------------------------------------------------------------

-- Example 2: GROUP BY with COUNT()

/*
    Count the number of customers in each country.

    COUNT() calculates the number of rows belonging to each group.

    COUNT(*) counts all rows in each group.
*/

SELECT
    customers.country,
    COUNT(*) AS number_of_customers
FROM study_notes.customers AS customers
GROUP BY
    customers.country;

-------------------------------------------------------------------------------

-- Example 3: GROUP BY with multiple aggregate functions

/*
    Calculate multiple statistics for each country.

    Aggregate functions commonly used with GROUP BY include:

        COUNT() - Counts rows or non-NULL values.
        MAX()   - Returns the maximum value.
        MIN()   - Returns the minimum value.
        SUM()   - Calculates the total.
        AVG()   - Calculates the average.
*/

SELECT
    orders.customer_id,
    COUNT(*) AS number_of_orders,
    SUM(orders.total_amount) AS total_amount,
    AVG(orders.total_amount) AS average_order_amount,
    MIN(orders.total_amount) AS smallest_order,
    MAX(orders.total_amount) AS largest_order
FROM study_notes.orders AS orders
GROUP BY
    orders.customer_id;

-------------------------------------------------------------------------------

-- Example 4: GROUP BY with ORDER BY

/*
    Order the results by the number of customers in each country.

    ORDER BY is applied after the groups have been calculated.

    DESC sorts the results from highest to lowest.
*/

SELECT
    customers.country,
    COUNT(*) AS number_of_customers
FROM study_notes.customers AS customers
GROUP BY
    customers.country
ORDER BY
    number_of_customers DESC;

-------------------------------------------------------------------------------

-- Example 5: GROUP BY with JOIN

/*
    Count the number of orders handled by each employee.

    JOIN combines the employees and orders tables.

    GROUP BY then groups the resulting rows by employee.

    COUNT() calculates the number of orders belonging to each employee.
*/

SELECT
    employees.employee_id,
    employees.name,
    COUNT(orders.order_id) AS number_of_orders
FROM study_notes.employees AS employees
    LEFT JOIN study_notes.orders AS orders
        ON employees.employee_id = orders.employee_id
GROUP BY
    employees.employee_id,
    employees.name;

-------------------------------------------------------------------------------

-- Example 6: GROUP BY with WHERE

/*
    WHERE filters rows before they are grouped.

    In this example, only orders with a total amount greater than 100
    are included when calculating the number of orders per customer.
*/

SELECT
    orders.customer_id,
    COUNT(*) AS number_of_orders
FROM study_notes.orders AS orders
WHERE
    orders.total_amount > 100
GROUP BY
    orders.customer_id;

-------------------------------------------------------------------------------

/*
    IMPORTANT: GROUP BY RULE

    When using GROUP BY, every column in the SELECT list must either:

        1. Appear in the GROUP BY clause.
        2. Be used inside an aggregate function.

    For example, the following is valid:

        SELECT
            orders.customer_id,
            COUNT(*)
        FROM study_notes.orders AS orders
        GROUP BY
            orders.customer_id;

    However, selecting orders.order_id without grouping by it or
    aggregating it would be invalid.

    This is because each group can contain multiple order IDs, and
    PostgreSQL would not know which one to return.
*/

-------------------------------------------------------------------------------

-- Practice

/*
    1. Count the number of orders placed by each customer.

    2. Calculate the total amount spent by each customer.

    3. Calculate the average order amount for each customer.

    4. Find the customer with the highest total spending.
*/
