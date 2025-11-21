/*markdown
# ASSIGNMENT: CTES

*/

/*markdown
## 1. List of all orders over $200 and number of orders over $200
*/

SELECT      *
FROM        orders
LIMIT       5

SELECT      product_id,
            unit_price
FROM        products
LIMIT       5

SELECT  o.order_id,
        (p.unit_price * o.units) AS amount_spent
FROM    products p
        LEFT JOIN orders o 
            ON p.product_id = o.product_id
LIMIT       10

WITH total_spent_per_product AS (
    SELECT  o.order_id,
            (p.unit_price * o.units) AS amount_spent
    FROM    products p
            LEFT JOIN orders o 
                ON p.product_id = o.product_id
)
SELECT      order_id,
            SUM(amount_spent) AS total_amount_spent
FROM        total_spent_per_product
GROUP BY    order_id
LIMIT       10         

WITH total_spent_per_product AS (
    SELECT      o.order_id,
                (p.unit_price * o.units) AS amount_spent
    FROM        products p
                LEFT JOIN orders o 
                ON p.product_id = o.product_id
),
total_spent_per_order AS (
    SELECT      order_id,
                SUM(amount_spent) AS total_amount_spent
    FROM        total_spent_per_product
    GROUP BY    order_id
)
SELECT      *
FROM        total_spent_per_order
WHERE       total_amount_spent > 200;

WITH total_spent_per_product AS (
    SELECT      o.order_id,
                (p.unit_price * o.units) AS amount_spent
    FROM        orders o 
                LEFT JOIN products p
                ON o.product_id = p.product_id
),
total_spent_per_order AS (
    SELECT      order_id,
                SUM(amount_spent) AS total_amount_spent
    FROM        total_spent_per_product
    GROUP BY    order_id
),
orders_over_200 AS (
    SELECT      *
    FROM        total_spent_per_order
    WHERE       total_amount_spent > 200
)
SELECT      COUNT(*)
FROM        orders_over_200

/*markdown
## ASSIGNMENT: Multiple CTEs
*/

SELECT      fp.factory,
            fp.product_name,
            fn.num_products
FROM        (
                SELECT      factory,
                            product_name
                FROM        products
            ) AS fp
            LEFT JOIN (
                SELECT      factory,
                            COUNT(product_id) AS num_products
                FROM        products
                GROUP BY    factory
            ) AS fn
                ON fp.factory = fn.factory
ORDER BY    fp.factory, fp.product_name


WITH fp AS (
    SELECT      factory,
                product_name
    FROM        products
),
fn AS (
    SELECT      factory,
                COUNT(product_id) AS num_products
    FROM        products
    GROUP BY    factory
)
SELECT      fp.factory,
            fp.product_name,
            fn.num_products
FROM        fp
            LEFT JOIN fn
                ON fp.factory = fn.factory
ORDER BY    fp.factory, fp.product_name