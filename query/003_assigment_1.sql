/*markdown
## `orders`
*/

SELECT      * 
FROM        orders 
WHERE       1=1;

/*markdown
## `products`
*/

SELECT      * 
FROM        products 
WHERE       1=1;

/*markdown
## Product Amount
*/

SELECT      COUNT(DISTINCT product_id)
FROM        orders
WHERE       1=1;

SELECT      COUNT(DISTINCT product_id)
FROM        products
WHERE       1=1;

/*markdown
## Joins
*/

SELECT
(
    SELECT      COUNT(*)
    FROM        orders o
                LEFT JOIN products p
                ON o.product_id = p.product_id
    WHERE       1=1
) AS order_id,
(
    SELECT      COUNT(*)
    FROM        orders o
                RIGHT JOIN products p
                ON o.product_id = p.product_id
    WHERE       1=1
) AS produts_id;

/*markdown
## Products that exists in products but not in orders
*/

SELECT
(
    SELECT      COUNT(*)
    FROM        orders o
                LEFT JOIN products p
                ON o.product_id = p.product_id
    WHERE       p.product_id IS NULL
) AS orders_with_null_products,
(
    SELECT      COUNT(*)
    FROM        orders o
                RIGHT JOIN products p
                ON o.product_id = p.product_id
    WHERE       o.product_id IS NULL
) AS products_with_null_orders;

/*markdown
## Final Query
*/

SELECT      *
FROM        orders o
            RIGHT JOIN products p
            ON o.product_id = p.product_id
WHERE       o.product_id IS NULL;

SELECT      p.product_id,
            p.product_id,
            o.product_id as order_product_id
FROM        products p
            LEFT JOIN orders o
            ON p.product_id = o.product_id
WHERE       o.product_id IS NULL;