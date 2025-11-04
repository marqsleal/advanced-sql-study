/*markdown
# Assigment 2: SELF JOINs
Write a query to determine which products are within 25 cents of each other in terms of unit price and return a list of all candy pairs
*/

SELECT      *
FROM        products
WHERE       1=1;

SELECT      p1.product_name,
            p1.unit_price,
            p2.product_name,
            p2.unit_price
FROM        products p1
            INNER JOIN products p2
                on p1.product_id <> p2.product_id;

SELECT      p1.product_name,
            p1.unit_price,
            p2.product_name,
            p2.unit_price,
            (
                p1.unit_price - p2.unit_price
            ) as price_difference
FROM        products p1
            INNER JOIN products p2
                on p1.product_id <> p2.product_id
WHERE       ABS(
                p1.unit_price - p2.unit_price
            ) < 0.25
            AND p1.product_name < p2.product_name
ORDER BY    price_difference DESC;