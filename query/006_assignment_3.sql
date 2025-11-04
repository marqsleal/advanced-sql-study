/*markdown
# Assignment 3
*/

/*markdown
## Subqueries in the `SELECT` clause
List of products from most to least expensive, along with how much each product differs from the average unit price
*/

SELECT      *
FROM        products
WHERE       1=1;

SELECT      *
FROM        products
WHERE       unit_price IS NOT NULL
ORDER BY    unit_price DESC;

SELECT      product_id,
            product_name,
            unit_price,
            ABS(unit_price - 
                (
                    SELECT      AVG(unit_price)
                    FROM        products
                )
            ) AS diff_price_avg
FROM        products
WHERE       unit_price IS NOT NULL
ORDER BY    unit_price DESC;

/*markdown
## Subqueries in the `FROM` clause
Return a country's happiness score for the year as well as the average happiness score for the country across years
*/

SELECT      country, 
            AVG(happiness_score) as avg_hs_by_country
FROM        happiness_scores
WHERE       1=1
GROUP BY    country;

SELECT      hs1.year,
            hs1.country,
            hs1.happiness_score,
            hs2.avg_hs_by_country
FROM        happiness_scores hs1
            LEFT JOIN(
                SELECT      country, 
                            AVG(happiness_score) as avg_hs_by_country
                FROM        happiness_scores
                GROUP BY    country
            ) AS hs2
                ON hs1.country = hs2.country