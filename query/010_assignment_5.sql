/*markdown
# Window Function
*/

/*markdown
## 1. Transaction Number for each customer
*/

SELECT      *
FROM        customers
LIMIT       5

SELECT      customer_id,
            order_id,
            order_date,
            transaction_id
FROM        orders
ORDER BY    customer_id,
            transaction_id
LIMIT       5

SELECT      customer_id,
            order_id,
            order_date,
            transaction_id,
            ROW_NUMBER() OVER(
                PARTITION BY    customer_id
                ORDER BY        transaction_id
            ) AS transaction_number
FROM        orders
ORDER BY    customer_id,
            transaction_id
LIMIT       5

/*markdown
## 2. Row Numbering
Create a product rank field that return a 1 for the most popular product in an order, 2 for the second most.
*/

SELECT      order_id,
            product_id,
            units,
            ROW_NUMBER() OVER(
                PARTITION BY    order_id
                ORDER BY        units DESC
            ) AS product_rn
FROM        orders
ORDER BY    order_id,
            product_rn
LIMIT       5

SELECT      order_id,
            product_id,
            units,
            RANK() OVER(
                PARTITION BY    order_id
                ORDER BY        units DESC
            ) AS product_rank
FROM        orders
ORDER BY    order_id,
            product_rank
LIMIT       5

SELECT      order_id,
            product_id,
            units,
            DENSE_RANK() OVER(
                PARTITION BY    order_id
                ORDER BY        units DESC
            ) AS product_rank
FROM        orders
ORDER BY    order_id,
            product_rank
LIMIT       5

/*markdown
## 3. ASSIGNMENT: Value Within a Window
2nd most popular product within each order
*/

SELECT      *
FROM        orders
LIMIT       10

WITH second_product_table AS(
    SELECT      order_id,
                product_id,
                units,
                NTH_VALUE(product_id, 2) OVER(
                    PARTITION BY    order_id
                    ORDER BY        units DESC
                ) AS sencond_product
    FROM        orders
)
SELECT      *
FROM        second_product_table
WHERE       product_id = sencond_product
LIMIT       5


WITH product_rank_table AS(
    SELECT      order_id,
                product_id,
                units,
                DENSE_RANK() OVER(
                    PARTITION BY    order_id
                    ORDER BY        units DESC
                ) AS product_rank
    FROM        orders
)
SELECT      *
FROM        product_rank_table
WHERE       product_rank = 2
LIMIT       5

/*markdown
## 4. ASSIGNMENT: Value Relative to a Row
Porduce a table that contains info about each customer and their order, the number of units in each order and the change in units from order to order
*/

SELECT      customer_id,
            order_id,
            product_id,
            units,
            0 AS total_units,
            0 AS prior_units,
            0 AS diff_units
FROM        orders
LIMIT       5

SELECT      customer_id,
            order_id,
            MIN(transaction_id) AS min_transaction_id,
            SUM(units) AS total_units
FROM        orders
GROUP BY    customer_id, 
            order_id
ORDER BY    customer_id,
            min_transaction_id
LIMIT       5

WITH min_transaction_table AS (
    SELECT      customer_id,
                order_id,
                MIN(transaction_id) AS min_transaction_id,
                SUM(units) AS total_units
    FROM        orders
    GROUP BY    customer_id, 
                order_id
    ORDER BY    customer_id,
                min_transaction_id
),
prior_transaction_table AS(
    SELECT      customer_id,
                order_id,
                total_units,
                LAG(total_units) OVER(
                    PARTITION BY    customer_id
                    ORDER BY        min_transaction_id
                ) AS prior_units
    FROM        min_transaction_table
)
SELECT      *,
            (
                total_units - prior_units
            )AS diff_units
FROM        prior_transaction_table
LIMIT       5

/*markdown
## 5. ASSIGNMENT: Statistical Functions
List of the top 1% of custormers in terms of how much they spent
*/

SELECT      customer_id,
            0 AS total_spend,
            0 AS spend_pct
FROM        orders
LIMIT       5

SELECT      customer_id,
            order_id,
            product_id,
            units
FROM        orders
LIMIT       5

SELECT      product_id,
            unit_price
FROM        products
LIMIT       5

SELECT      o.customer_id,
            SUM(
                o.units * p.unit_price
            ) AS total_spend
FROM        orders o
            LEFT JOIN products p
                ON o.product_id = p.product_id
GROUP BY    o.customer_id
ORDER BY    total_spend DESC
LIMIT       5

WITH total_spend_table AS (
    SELECT      o.customer_id,
                SUM(
                    o.units * p.unit_price
                ) AS total_spend
    FROM        orders o
                LEFT JOIN products p
                    ON o.product_id = p.product_id
    GROUP BY    o.customer_id
    ORDER BY    total_spend DESC
),
spend_pct_table AS (
    SELECT      customer_id,
                total_spend,
                NTILE(100) OVER(
                    ORDER BY total_spend DESC
                ) AS spend_pct
    FROM        total_spend_table
)
SELECT      *
FROM        spend_pct_table
WHERE       spend_pct = 1

