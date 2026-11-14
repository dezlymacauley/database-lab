/*
    ABOUT: CROSS JOIN
*/
-------------------------------------------------------------------------------

CREATE TABLE study_notes.stores (
    store_name TEXT
);

INSERT INTO study_notes.stores (
    store_name
)
VALUES
('Store A'),
('Store B');
-------------------------------------------------------------------------------

CREATE TABLE study_notes.sales (
    store_name TEXT,
    sale_date DATE,
    amount INT4
);

INSERT INTO study_notes.sales (
    store_name,
    sale_date,
    amount
)
VALUES
('Store A', '2026-08-15', 100),
('Store A', '2026-08-28', 50),
('Store A', '2026-10-05', 250),
('Store B', '2026-09-12', 80);
-------------------------------------------------------------------------------

-- Without a cross join, you only see months that had sales:
SELECT
    store_name,
    date_trunc('month', sale_date)::DATE AS sales_month,
    sum(amount) AS total_sales
FROM study_notes.sales
GROUP BY
    store_name,
    date_trunc('month', sale_date)
ORDER BY
    store_name,
    sales_month;

/*
+------------+-------------+-------------+
| store_name | sales_month | total_sales |
|------------+-------------+-------------|
| Store A    | 2026-08-01  | 150         |
| Store A    | 2026-10-01  | 250         |
| Store B    | 2026-09-01  | 80          |
+------------+-------------+-------------+

Store A has no September row, and Store B has no August or October rows.
*/
-------------------------------------------------------------------------------

-- SECTION: Show every store for every month, with 0 when there were no sales

SELECT
    stores.store_name,
    months.month::DATE AS sales_month,
    coalesce(sum(sales.amount), 0) AS total_sales
FROM study_notes.stores
    CROSS JOIN
        generate_series(
            '2026-08-01'::DATE,
            '2026-10-01'::DATE,
            '1 month'
        ) AS months (month)
    LEFT JOIN study_notes.sales
        ON
            stores.store_name = sales.store_name
            AND date_trunc('month', sales.sale_date)::DATE = months.month::DATE
GROUP BY
    stores.store_name,
    months.month
ORDER BY
    stores.store_name,
    months.month;

/*
+------------+-------------+-------------+
| store_name | sales_month | total_sales |
|------------+-------------+-------------|
| Store A    | 2026-08-01  | 150         |
| Store A    | 2026-09-01  | 0           |
| Store A    | 2026-10-01  | 250         |
| Store B    | 2026-08-01  | 0           |
| Store B    | 2026-09-01  | 80          |
| Store B    | 2026-10-01  | 0           |
+------------+-------------+-------------+
*/

-- 2 stores * 3 months = 6 rows, even though sales only exist in 4 of the combinations
